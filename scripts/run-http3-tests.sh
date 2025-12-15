#!/bin/bash

#############################################
# HTTP/3 QUIC Communication Validation Tests
# Ensures 100% test success rate
#############################################

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}HTTP/3 QUIC Communication Validation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

#############################################
# Function: Run Core Application HTTP/3 Tests
#############################################
run_core_http3_tests() {
    echo -e "${YELLOW}[1/3] Running Core Application HTTP/3 Tests...${NC}"
    echo ""

    cd "$PROJECT_ROOT/Core/Application"

    # Check if test file exists
    if [ ! -f "tests/http3/http3_communication_test.go" ]; then
        echo -e "${RED}Error: HTTP/3 tests not found${NC}"
        echo "Expected: tests/http3/http3_communication_test.go"
        return 1
    fi

    # Run tests with verbose output
    echo "Running: go test ./tests/http3/... -v -count=1"
    if go test ./tests/http3/... -v -count=1 2>&1 | tee /tmp/core-http3-tests.log; then
        echo -e "${GREEN}✓ Core HTTP/3 tests PASSED${NC}"

        # Count passed tests
        CORE_PASSED=$(grep -c "PASS:" /tmp/core-http3-tests.log || echo "0")
        TOTAL_TESTS=$((TOTAL_TESTS + CORE_PASSED))
        PASSED_TESTS=$((PASSED_TESTS + CORE_PASSED))
    else
        echo -e "${RED}✗ Core HTTP/3 tests FAILED${NC}"

        # Count failed tests
        CORE_FAILED=$(grep -c "FAIL:" /tmp/core-http3-tests.log || echo "0")
        TOTAL_TESTS=$((TOTAL_TESTS + CORE_FAILED))
        FAILED_TESTS=$((FAILED_TESTS + CORE_FAILED))

        return 1
    fi

    echo ""
}

#############################################
# Function: Run Localization Service HTTP/3 Tests
#############################################
run_localization_http3_tests() {
    echo -e "${YELLOW}[2/3] Running Localization Service HTTP/3 Tests...${NC}"
    echo ""

    cd "$PROJECT_ROOT/Core/Services/Localization"

    # Run existing tests
    echo "Running: go test ./... -v -count=1"
    if go test ./... -v -count=1 2>&1 | tee /tmp/localization-http3-tests.log; then
        echo -e "${GREEN}✓ Localization HTTP/3 tests PASSED${NC}"

        # Count passed tests
        LOC_PASSED=$(grep -c "PASS:" /tmp/localization-http3-tests.log || echo "0")
        TOTAL_TESTS=$((TOTAL_TESTS + LOC_PASSED))
        PASSED_TESTS=$((PASSED_TESTS + LOC_PASSED))
    else
        echo -e "${RED}✗ Localization HTTP/3 tests FAILED${NC}"

        # Count failed tests
        LOC_FAILED=$(grep -c "FAIL:" /tmp/localization-http3-tests.log || echo "0")
        TOTAL_TESTS=$((TOTAL_TESTS + LOC_FAILED))
        FAILED_TESTS=$((FAILED_TESTS + LOC_FAILED))

        return 1
    fi

    echo ""
}

#############################################
# Function: Run Integration Tests
#############################################
run_integration_tests() {
    echo -e "${YELLOW}[3/3] Running HTTP/3 Integration Tests...${NC}"
    echo ""

    cd "$PROJECT_ROOT/Core/Application"

    # Check if integration tests exist
    if [ -f "tests/integration/http3_integration_test.go" ]; then
        echo "Running: go test ./tests/integration/... -v -count=1"
        if go test ./tests/integration/... -v -count=1 2>&1 | tee /tmp/integration-http3-tests.log; then
            echo -e "${GREEN}✓ Integration tests PASSED${NC}"

            # Count passed tests
            INT_PASSED=$(grep -c "PASS:" /tmp/integration-http3-tests.log || echo "0")
            TOTAL_TESTS=$((TOTAL_TESTS + INT_PASSED))
            PASSED_TESTS=$((PASSED_TESTS + INT_PASSED))
        else
            echo -e "${RED}✗ Integration tests FAILED${NC}"

            # Count failed tests
            INT_FAILED=$(grep -c "FAIL:" /tmp/integration-http3-tests.log || echo "0")
            TOTAL_TESTS=$((TOTAL_TESTS + INT_FAILED))
            FAILED_TESTS=$((FAILED_TESTS + INT_FAILED))

            return 1
        fi
    else
        echo -e "${YELLOW}⊘ Integration tests not found (optional)${NC}"
    fi

    echo ""
}

#############################################
# Function: Generate Test Report
#############################################
generate_test_report() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Test Results Summary${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "Total Tests Run: $TOTAL_TESTS"
    echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"

    if [ $FAILED_TESTS -gt 0 ]; then
        echo -e "${RED}Failed: $FAILED_TESTS${NC}"
    else
        echo "Failed: $FAILED_TESTS"
    fi

    # Calculate success rate
    if [ $TOTAL_TESTS -gt 0 ]; then
        SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        echo ""
        echo "Success Rate: $SUCCESS_RATE%"

        if [ $SUCCESS_RATE -eq 100 ]; then
            echo -e "${GREEN}✓✓✓ 100% SUCCESS - ALL TESTS PASSED! ✓✓✓${NC}"
        else
            echo -e "${RED}✗✗✗ NOT 100% - SOME TESTS FAILED ✗✗✗${NC}"
        fi
    fi

    echo -e "${BLUE}========================================${NC}"
}

#############################################
# Main Execution
#############################################
main() {
    local exit_code=0

    # Run all test suites
    run_core_http3_tests || exit_code=1
    run_localization_http3_tests || exit_code=1
    run_integration_tests || exit_code=1

    # Generate report
    echo ""
    generate_test_report

    # Save report to file
    generate_test_report > "$PROJECT_ROOT/HTTP3_TEST_RESULTS.txt"
    echo ""
    echo "Test results saved to: HTTP3_TEST_RESULTS.txt"

    # Exit with appropriate code
    if [ $exit_code -ne 0 ] || [ $FAILED_TESTS -gt 0 ]; then
        echo ""
        echo -e "${RED}Some tests failed. Please review the logs above.${NC}"
        exit 1
    else
        echo ""
        echo -e "${GREEN}All tests passed successfully!${NC}"
        exit 0
    fi
}

# Run main function
main "$@"

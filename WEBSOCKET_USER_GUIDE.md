# WebSocket Real-Time Updates - User Guide

**Version:** 1.0.0
**Date:** 2025-10-21
**Audience:** End Users, Translators, Administrators

---

## 📖 Table of Contents

1. [Introduction](#introduction)
2. [What are Real-Time Updates?](#what-are-real-time-updates)
3. [Getting Started](#getting-started)
4. [Connection Status](#connection-status)
5. [Feature Overview](#feature-overview)
6. [Common Scenarios](#common-scenarios)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)
9. [FAQ](#faq)

---

## 🎯 Introduction

The HelixTrack Localization Management system now includes **real-time updates** powered by WebSocket technology. This means that when anyone on your team makes changes to translations, languages, or other localization data, **everyone sees those changes instantly** without needing to manually refresh their browser.

### Benefits

✅ **Instant Synchronization** - See changes from teammates immediately
✅ **Prevent Conflicts** - Get notified when others are editing the same content
✅ **Improved Collaboration** - Work together seamlessly with your team
✅ **Better Awareness** - Know who made what changes and when
✅ **No Manual Refresh** - Data updates automatically in the background

---

## 🌐 What are Real-Time Updates?

### Before Real-Time Updates (Old Behavior)

```
User A: Adds a new translation
    ↓
Backend: Saves to database
    ↓
User B: Sees old data
    ↓
User B: Must manually refresh browser (F5)
    ↓
User B: Now sees User A's changes
```

**Problems:**
- ❌ Users unaware of changes made by others
- ❌ Risk of overwriting each other's work
- ❌ Constant manual refreshing needed
- ❌ Delayed awareness of system changes

### With Real-Time Updates (New Behavior)

```
User A: Adds a new translation
    ↓
Backend: Saves to database
    ↓
Backend: Broadcasts WebSocket event
    ↓
All Users: Receive event instantly
    ↓
All Browsers: Automatically update UI
    ↓
Everyone: Sees the new translation immediately
```

**Benefits:**
- ✅ Instant awareness of all changes
- ✅ Automatic conflict prevention
- ✅ No manual refresh needed
- ✅ See who made what changes

---

## 🚀 Getting Started

### Prerequisites

**For End Users:**
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Active internet connection
- Access to HelixTrack Localization system

**For Administrators:**
- Localization service running with WebSocket support
- Backend URL configured correctly
- Firewall allows WebSocket connections (port 8085 by default)

### Accessing the System

1. **Open your browser** and navigate to the HelixTrack Web Client
   ```
   https://your-domain.com/admin/localization
   ```

2. **Log in** with your credentials

3. **Check connection status** in the sidebar
   - Look for the connection indicator at the top of the sidebar
   - **Green "Connected"** = Real-time updates active ✅
   - **Red "Disconnected"** = Real-time updates inactive ❌

4. **Start working** - Real-time updates are automatic!

### No Configuration Needed

Real-time updates are **enabled by default** for all users. There's nothing you need to configure or turn on - it just works!

---

## 📡 Connection Status

### Understanding the Connection Indicator

The connection status indicator is located in the **sidebar** of the Localization Management interface.

#### Connected State

```
┌─────────────────────┐
│  🟢  Connected      │
└─────────────────────┘
```

**What it means:**
- ✅ WebSocket connection established
- ✅ Real-time updates active
- ✅ You'll see changes immediately
- ✅ Others will see your changes immediately

**Tooltip:** "Real-time updates active"

#### Disconnected State

```
┌─────────────────────┐
│  🔴  Disconnected   │
└─────────────────────┘
```

**What it means:**
- ❌ WebSocket connection lost
- ❌ Real-time updates inactive
- ⚠️ You may need to manually refresh
- ⚠️ System is trying to reconnect automatically

**Tooltip:** "Real-time updates inactive"

### Automatic Reconnection

If the connection is lost (due to network issues, server restart, etc.), the system will **automatically attempt to reconnect** every few seconds.

**Reconnection Process:**
1. Connection lost → Indicator turns **red**
2. System waits 5 seconds
3. Attempts to reconnect
4. If fails, waits 10 seconds (exponential backoff)
5. Repeats until successful
6. Connection restored → Indicator turns **green**

**What to do:**
- ✅ **Nothing!** The system handles reconnection automatically
- ⚠️ If disconnected for more than 1 minute, check your internet connection
- ⚠️ If repeatedly disconnecting, contact your administrator

---

## ✨ Feature Overview

### 1. Dashboard Auto-Refresh

**Location:** Dashboard page

**What it does:**
- Automatically updates statistics when data changes
- Shows latest counts for languages, keys, translations
- Refreshes progress bars in real-time

**Example:**
```
Translator A: Approves 10 translations
    ↓
Dashboard: "Approved" count increases automatically
    ↓
Everyone's dashboard: Shows updated statistics
```

**What you see:**
- Statistics update without page refresh
- Progress bars animate to new values
- No visual interruption to your work

---

### 2. Translation Editor Real-Time Updates

**Location:** Translation Editor page

**What it does:**
- Shows when others edit translations
- Prevents you from overwriting someone else's work
- Automatically refreshes when safe to do so

#### Scenario A: No Unsaved Changes

```
You: Viewing translation grid (no edits)
    ↓
Teammate: Saves translation for "app.welcome"
    ↓
Your Screen: Shows notification + auto-refreshes
    ↓
You see: Updated translation immediately
```

**Notification:**
```
ℹ️ Translations updated by another user. Refreshing...
```

#### Scenario B: You Have Unsaved Changes

```
You: Editing translation for "app.goodbye" (unsaved)
    ↓
Teammate: Saves translation for "app.welcome"
    ↓
Your Screen: Shows warning (does NOT auto-refresh)
    ↓
You: Must save or discard your changes to see updates
```

**Notification:**
```
⚠️ Translations updated by another user.
   Save or discard your changes to see updates.
```

**Why this happens:**
- Prevents losing your unsaved work
- Gives you control over when to refresh
- Avoids confusion from sudden data changes

**What to do:**
1. **Option A:** Save your changes, then data will auto-refresh
2. **Option B:** Discard your changes to see latest data
3. **Option C:** Continue editing, refresh later

---

### 3. Language List Live Updates

**Location:** Languages page

**What it does:**
- Shows language additions/updates/deletions in real-time
- Displays who made the change
- Automatically updates the language list

**Notifications:**

**Language Added:**
```
✅ Language "French" added by john.doe
```

**Language Updated:**
```
ℹ️ Language "Spanish" updated by jane.smith
```

**Language Deleted:**
```
⚠️ Language "German" deleted by admin
```

**What you see:**
- Notification appears at bottom of screen
- Language list automatically refreshes
- New/updated languages appear immediately
- Deleted languages disappear immediately

---

### 4. Version History Real-Time Tracking

**Location:** Version History page

**What it does:**
- Shows new versions as they're created
- Notifies when versions are deleted
- Automatically updates the version list

**Notifications:**

**Version Created:**
```
📝 Version 1.0.5 created for English Catalog by admin
```

**Version Deleted:**
```
🗑️ Version 1.0.3 deleted by admin
```

---

### 5. Batch Import Progress

**Location:** All pages

**What it does:**
- Notifies all users when batch imports complete
- Triggers automatic data refresh across all components
- Shows import summary

**Notification:**
```
✅ Batch import completed. Refreshing...
   1,000 translations imported, 5 failed
```

**What happens:**
- All open pages refresh their data
- Dashboard updates statistics
- Translation grids reload
- Language lists update

---

## 🎭 Common Scenarios

### Scenario 1: Two Translators Working Simultaneously

**Situation:** You and a colleague are both translating content at the same time.

**What happens:**

1. **Colleague translates** "app.welcome" to Spanish
   - You see: `ℹ️ Translations updated by maria.garcia. Refreshing...`
   - Your grid: Auto-refreshes (if you haven't made edits)

2. **You translate** "app.goodbye" to Spanish
   - Colleague sees: `ℹ️ Translations updated by you. Refreshing...`
   - Their grid: Auto-refreshes

3. **Both trying to edit the same key**
   - First to save: Succeeds
   - Second to save: Sees warning, can choose to overwrite or discard

**Result:**
- ✅ Both see each other's work immediately
- ✅ No data loss
- ✅ Clear communication via notifications

---

### Scenario 2: Admin Adds New Language

**Situation:** Admin adds a new language to the system.

**What happens:**

1. **Admin adds "Japanese"** via Languages page
2. **All users see notification:**
   ```
   ✅ Language "Japanese" added by admin
   ```
3. **Automatic updates:**
   - Language lists refresh
   - Language selectors include "Japanese"
   - Translation grids show new Japanese column
   - Dashboard shows updated language count

**Result:**
- ✅ Everyone aware of new language immediately
- ✅ Can start translating right away
- ✅ No manual refresh or page reload needed

---

### Scenario 3: Batch Import During Active Work

**Situation:** You're working on translations when someone imports a large dataset.

**What happens:**

1. **You're editing translations** in the editor
2. **Admin starts batch import** of 1,000 translations
3. **Import completes** after 30 seconds
4. **You see notification:**
   ```
   ⚠️ Batch import completed.
      Save or discard your changes to see updates.
   ```
5. **You finish editing** and click Save
6. **After save:** Grid automatically refreshes with all imported data

**Result:**
- ✅ Your work is protected
- ✅ You're aware of the import
- ✅ You control when to see new data

---

### Scenario 4: Network Disconnection

**Situation:** Your internet connection drops temporarily.

**What happens:**

1. **Connection lost**
   - Indicator turns **red**
   - System detects disconnection

2. **Automatic reconnection attempts**
   - Every 5-10 seconds
   - Up to 10 attempts
   - Exponential backoff

3. **Connection restored**
   - Indicator turns **green**
   - You see: `✅ Reconnected`
   - Real-time updates resume

**What you should do:**
- ⏸️ **Wait** - Usually reconnects automatically within 30 seconds
- 🔍 **Check** - If red for >1 minute, check your internet connection
- 🔄 **Refresh** - If stuck, manually refresh the page (F5)

---

## 💡 Best Practices

### For Translators

1. **Save Frequently**
   - Save your work regularly to avoid conflicts
   - Don't leave unsaved edits for long periods

2. **Watch for Notifications**
   - Pay attention to update notifications
   - They tell you who changed what

3. **Coordinate with Team**
   - Use chat/communication tools to avoid editing the same content
   - Real-time updates help, but coordination is still important

4. **Check Connection Status**
   - Glance at the sidebar indicator occasionally
   - If red for more than a minute, investigate

### For Administrators

1. **Communicate Large Changes**
   - Let team know before batch imports
   - Schedule major updates during low-activity periods

2. **Monitor Connection Status**
   - Ensure WebSocket server is running
   - Check server logs for connection issues

3. **Educate Users**
   - Train team on real-time update features
   - Explain conflict prevention mechanisms

### For Everyone

1. **Trust the System**
   - No need to manually refresh (F5)
   - Let automatic updates work

2. **Read Notifications**
   - They provide valuable context
   - Ignore at your own risk

3. **Report Issues**
   - If updates aren't working, report to admin
   - Include screenshot of connection status

---

## 🔧 Troubleshooting

### Problem 1: Connection Status Shows "Disconnected"

**Symptoms:**
- Red indicator in sidebar
- No real-time updates
- Manual refresh needed

**Possible Causes:**
1. Internet connection lost
2. Backend server down
3. Firewall blocking WebSocket
4. Browser extension interfering

**Solutions:**

**Step 1:** Check your internet connection
```
- Try opening another website
- Ping a public server
- Check WiFi/Ethernet connection
```

**Step 2:** Wait for automatic reconnection
```
- System retries every 5-60 seconds
- Give it 1-2 minutes
```

**Step 3:** Manually refresh the page
```
- Press F5 or Ctrl+R
- Should reconnect on page load
```

**Step 4:** Contact administrator
```
- If still disconnected after 5 minutes
- Provide timestamp and screenshot
```

---

### Problem 2: Not Seeing Updates from Other Users

**Symptoms:**
- Connection status shows "Connected"
- But you don't see changes made by others
- Manual refresh (F5) shows the changes

**Possible Causes:**
1. You have unsaved edits (translation editor)
2. WebSocket events not firing
3. Component not subscribed to events

**Solutions:**

**Step 1:** Check for unsaved changes
```
- Translation Editor: Look for dirty/unsaved rows
- Save or discard your changes
- Should auto-refresh after save
```

**Step 2:** Check browser console
```
- Press F12 to open developer tools
- Look for WebSocket errors in Console tab
- Look for "[WebSocket] Connected" message
```

**Step 3:** Try disconnecting and reconnecting
```
- Close the browser tab
- Wait 10 seconds
- Open a new tab and log in again
```

**Step 4:** Clear browser cache
```
- Ctrl+Shift+Delete (Chrome/Firefox)
- Clear cached images and files
- Refresh the page
```

---

### Problem 3: Constant Reconnection (Flapping)

**Symptoms:**
- Connection status flips between green/red rapidly
- Notifications about reconnecting repeatedly

**Possible Causes:**
1. Unstable internet connection
2. Server restarts/updates
3. Network congestion
4. Firewall rules

**Solutions:**

**Step 1:** Check network stability
```
- Run continuous ping: ping google.com -t
- Look for packet loss or high latency
- Switch to wired connection if on WiFi
```

**Step 2:** Contact administrator
```
- May be server-side issue
- Administrator can check WebSocket server logs
```

**Step 3:** Disable browser extensions
```
- Some extensions block WebSockets
- Try disabling ad-blockers temporarily
- Test in incognito/private mode
```

---

### Problem 4: Notifications Not Showing

**Symptoms:**
- Connection status shows "Connected"
- Data updates correctly
- But no notification messages appear

**Possible Causes:**
1. Notifications dismissed too quickly
2. Browser notification settings
3. Screen resolution (notifications off-screen)

**Solutions:**

**Step 1:** Check notification duration
```
- Most notifications auto-dismiss after 3-5 seconds
- Watch the bottom of the screen carefully
```

**Step 2:** Check browser settings
```
- Ensure browser allows notifications
- Check site-specific notification settings
```

**Step 3:** Adjust screen zoom
```
- If zoomed in/out significantly, try 100% zoom
- Notifications may be off-screen
```

---

### Problem 5: Performance Issues After Long Session

**Symptoms:**
- Browser becomes slow after hours of use
- Memory usage high
- Lag when switching between components

**Possible Causes:**
1. Memory leaks (unlikely, but possible)
2. Too many WebSocket events accumulated
3. Browser cache buildup

**Solutions:**

**Step 1:** Refresh the page
```
- Press F5 to reload
- Clears accumulated events
- Resets WebSocket connection
```

**Step 2:** Close and reopen browser
```
- Completely close all browser windows
- Restart browser application
- Log in again
```

**Step 3:** Clear browser data
```
- Clear cache and cookies
- Restart browser
```

---

## ❓ FAQ

### General Questions

**Q: Do I need to do anything to enable real-time updates?**

A: No! Real-time updates are enabled by default for all users. Just log in and start working.

---

**Q: Will I see changes made by users in other departments?**

A: Yes, as long as you have permission to view the data. Real-time updates work across all users who have access to the Localization Management system.

---

**Q: Can I turn off real-time updates?**

A: Currently, no. Real-time updates are always enabled. However, if you have unsaved changes in the Translation Editor, the system won't auto-refresh to protect your work.

---

**Q: Do real-time updates use a lot of bandwidth?**

A: No. WebSocket connections are very efficient. Typical usage is less than 10KB per hour, even with frequent updates.

---

**Q: Will real-time updates work on my phone/tablet?**

A: Yes! As long as you're using a modern browser (Chrome, Safari, Firefox), real-time updates work on all devices.

---

### Technical Questions

**Q: What is WebSocket?**

A: WebSocket is a communication protocol that provides a persistent, two-way connection between your browser and the server. Unlike regular HTTP requests, WebSocket stays open and can send data in both directions instantly.

---

**Q: What happens if my connection is slow?**

A: Real-time updates are designed to work on slow connections. You might see a slight delay (a few seconds), but updates will still arrive automatically. If your connection is extremely slow, you may see intermittent disconnections.

---

**Q: Can admins see that I'm connected?**

A: Admins can see how many users are connected to the WebSocket server, but not which specific users unless they check server logs.

---

**Q: What data is sent over WebSocket?**

A: Only event notifications are sent (e.g., "Language added", "Translation updated"). The actual full data is fetched via regular HTTP requests. This keeps WebSocket traffic minimal and efficient.

---

**Q: Is WebSocket secure?**

A: Yes! WebSocket connections use **WSS** (WebSocket Secure), which is encrypted just like HTTPS. Your data is protected in transit.

---

### Troubleshooting Questions

**Q: Why do I see "Disconnected" sometimes?**

A: This can happen due to:
- Temporary network issues
- Server maintenance/restart
- Browser going into sleep mode (laptop lid closed)
- Firewall/proxy interference

The system automatically reconnects within a few seconds in most cases.

---

**Q: I saved my translation but others don't see it. Why?**

A: Possible reasons:
1. They have unsaved changes (system protects their work)
2. Their connection is lost (check their status indicator)
3. They're viewing a different language or filtered view
4. Cache issue (they should try refreshing)

---

**Q: Can two people edit the same translation at the same time?**

A: Technically yes, but the system helps prevent conflicts:
1. Last save wins (most recent change is kept)
2. If you're editing and someone else saves, you get a warning
3. You can choose to overwrite their change or discard yours

Best practice: Coordinate with your team to avoid editing the same content simultaneously.

---

**Q: What happens if I lose connection while editing?**

A: Your work is safe! Unsaved changes are kept in your browser. The system will try to reconnect automatically. Once reconnected, you can save as normal. If reconnection fails, you can:
1. Save your changes to a text file
2. Refresh the page
3. Paste your changes back in

---

## 📞 Getting Help

### For Users

**If you're experiencing issues:**

1. **Check this guide** - Most issues have solutions here
2. **Ask your administrator** - They can check server-side logs
3. **Report a bug** - Use your organization's support channel

### For Administrators

**If users are reporting issues:**

1. **Check WebSocket server status**
   ```bash
   curl https://localhost:8085/ws
   # Should respond with 400 (expected for HTTP to WebSocket)
   ```

2. **Check server logs**
   ```bash
   tail -f /var/log/localization-service/websocket.log
   ```

3. **Verify firewall rules**
   ```bash
   # Ensure port 8085 is open for WebSocket connections
   sudo ufw status | grep 8085
   ```

4. **Monitor active connections**
   ```bash
   # Check WebSocket server metrics
   curl https://localhost:8085/health
   ```

---

## 📚 Additional Resources

### Documentation

- [WebSocket Client Integration](WEBSOCKET_CLIENT_INTEGRATION_COMPLETE.md) - Technical details
- [Component Integration](WEB_CLIENT_COMPONENT_INTEGRATION_COMPLETE.md) - Component-level docs
- [Testing Summary](WEBSOCKET_TESTING_SUMMARY.md) - Test coverage
- [Integration Test Plan](WEBSOCKET_INTEGRATION_TEST_PLAN.md) - Testing strategy

### External Links

- [WebSocket Protocol (RFC 6455)](https://tools.ietf.org/html/rfc6455)
- [WebSocket Security](https://www.websocket.org/aboutwebsocket.html)

---

## 🎉 Conclusion

Real-time updates make collaboration seamless and efficient. You no longer need to manually refresh or worry about overwriting each other's work. The system keeps everyone in sync automatically!

**Key Takeaways:**

✅ Real-time updates are automatic - no configuration needed
✅ Connection status indicator shows if you're connected
✅ Notifications keep you informed of changes
✅ Conflict prevention protects your unsaved work
✅ Automatic reconnection handles network issues

**Enjoy seamless real-time collaboration with HelixTrack Localization!** 🚀

---

**Document Version:** 1.0.0
**Last Updated:** 2025-10-21
**Author:** HelixTrack Development Team
**Feedback:** Report issues via your organization's support channel

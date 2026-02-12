#  Genie Chat Widget - Local Testing Guide

A modern, professional chat widget interface for Databricks Genie - just like the McKesson career site!

##  Features

-  Clean, modern UI with floating chat button
-  Simple conversation interface (text only, no tables/SQL)
-  Notification badge
-  Quick action buttons for common questions
-  Fully responsive design
-  Focus on answers, not technical details
-  100% local and secure

##  Quick Start

### 1. Start Your FastAPI Backend

```bash
cd ~/path/to/genie-fastapi-service

# Make sure .env is configured
source .env

# Activate virtual environment
source venv/bin/activate

# Start the API
python app.py
```

Keep this terminal running!

### 2. Open the Chat Widget

Simply open the HTML file in your browser:

```bash
# Option 1: Direct file open
open genie-chat-widget.html

# Option 2: Serve with Python (recommended)
cd ~/path/to/chat-widget
python3 -m http.server 8002

# Then open: http://localhost:8002/genie-chat-widget.html
```

##  How to Use

### Opening the Chat
1. Look for the purple chat button in the bottom-right corner
2. Click it to open the chat window

### Asking Questions
1. Type your question in the input box at the bottom
2. Press Enter or click the send button
3. Wait for Genie's response (may take 30-120 seconds)

### Quick Actions
- Click any of the suggested question buttons for instant queries
- Great for first-time users or common questions

### Conversation Flow
- The widget maintains conversation context automatically
- You can ask follow-up questions
- Responses are clean summaries (no SQL or tables)

##  Sample Questions

**Simple Queries:**
- "What are our total sales?"
- "How many customers do we have?"
- "Show me recent trends"

**Analytical Questions:**
- "What are the top performing products?"
- "Compare sales by region"
- "What's our customer growth?"

**Aggregations:**
- "What is the average order value?"
- "Calculate total revenue this quarter"
- "Show customer retention rate"

##  What Makes This Different?

### vs. Full Test Console

| Feature | Chat Widget | Test Console |
|---------|-------------|--------------|
| **UI Style** | Floating chat bubble | Full-page dashboard |
| **Display** | Simple text answers | Tables, SQL, status |
| **Use Case** | End-user friendly | Developer testing |
| **Location** | Bottom-right corner | Whole page |
| **Response** | Clean summaries | Complete data |

### Key Differences:
-  **Chat Widget**: For actual users, clean interface, conversation-focused
-  **Test Console**: For developers, detailed debugging, see everything

##  Customization

You can easily customize the widget by editing the HTML file:

### Change Colors
Find the gradient in the CSS (around line 60):
```css
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```
Replace with your brand colors!

### Change Position
Find `.chat-widget-button` (around line 40):
```css
bottom: 30px;  /* Distance from bottom */
right: 30px;   /* Distance from right */
```

### Change Avatar
Find the emoji in the HTML:
```html
<div class="chat-avatar">🧞</div>
```
Replace 🧞 with any emoji or add an image!

### Change Welcome Message
Find the welcome message section:
```html
<div class="welcome-message">
     Hi! I'm Genie...
</div>
```

## 🧪 Testing Checklist

- [ ] Backend API running (check http://localhost:8000/health)
- [ ] Chat widget opens when clicking button
- [ ] Can send messages
- [ ] Receives responses from Genie
- [ ] Typing indicator shows while processing
- [ ] Quick action buttons work
- [ ] Conversation context maintained
- [ ] Close button works
- [ ] Notification badge appears/disappears

## 🔒 Security & Privacy

This setup is completely safe:
-  Runs locally on localhost only
-  No external connections except to your Databricks
-  No data stored in browser permanently
-  Session data in memory only
-  Same security as your FastAPI backend

##  When You're Done

### Close Everything:

**Terminal 1 (FastAPI):**
```bash
Ctrl+C
```

**Terminal 2 (Chat Widget Server - if using):**
```bash
Ctrl+C
```

**Browser:**
- Just close the tab

### Full Cleanup:
```bash
# Kill any lingering processes
lsof -ti:8000 | xargs kill -9
lsof -ti:8002 | xargs kill -9

# Deactivate virtual environment
deactivate
```

## 📊 Response Format

The widget shows **only answer summaries**:

 **NOT shown:**
- SQL queries
- Raw data tables
- Status codes
- Technical details
- Session IDs

 **Shown:**
- Natural language answers
- Summary statistics
- Result counts when relevant
- Easy-to-understand insights

##  Conversation Examples

**User:** What are our total sales?  
**Genie:** Based on the data, your total sales are $2.5M across all regions. This includes 1,234 transactions.

**User:** Which region is performing best?  
**Genie:** The West region is your top performer with $950K in sales, followed by East with $720K.

**User:** Show me the trend  
**Genie:** Sales have grown 15% month-over-month, with strong performance in Q4.

##  Deploying to Your Organization

Once tested locally, you can:

1. **Embed in internal portal**: Add this HTML to your company intranet
2. **Deploy as separate app**: Host on internal web server
3. **Integrate with Teams**: Use as basis for Teams bot UI
4. **Add to existing apps**: Embed widget in current applications

##  Next Steps

1.  Test locally with various questions
2.  Customize colors/branding to match your org
3.  Get feedback from colleagues
4.  Deploy to Azure when ready
5.  Build Teams integration

##  Troubleshooting

### Chat button doesn't appear
- Check browser console for errors (F12)
- Ensure HTML file loaded completely

### Can't send messages
- Verify FastAPI is running: http://localhost:8000/health
- Check browser console for connection errors
- Confirm no CORS issues

### No response from Genie
- Check FastAPI terminal for error logs
- Verify .env variables are correct
- Test with simple query first

### Widget looks weird
- Clear browser cache
- Use modern browser (Chrome, Firefox, Safari, Edge)
- Check for JavaScript errors in console

##  Features Coming Soon

Want to add more features? Easy modifications:

-  File attachments
-  Theme switcher (light/dark)
-  Export conversation
-  Text-to-speech
-  Multi-language support
-  Native mobile app version

---

# Start Here

Plain-English setup. Works on any Mac. Takes about ten minutes the first time,
about thirty seconds every time after that.

You'll be copying and pasting four commands into an app called Terminal. You
don't need to understand them.

---

## Open Terminal

Press **Command + Space**, type `Terminal`, press **Return**. A window with
text in it opens. That's where everything below goes.

Paste one command, press Return, wait for it to finish, then do the next one.

> **Note:** when you paste a command that has a `#` comment in it, Terminal may
> complain. Paste the commands exactly as shown below — they have no comments.

---

## Step 1 — Install Apple's developer tools

```
xcode-select --install
```

A window pops up. Click **Install** and wait. It can take five to fifteen
minutes.

If it says *"command line tools are already installed"*, you're fine — move on.

---

## Step 2 — Install Claude Code and sign in

```
npm install -g @anthropic-ai/claude-code
```

If that fails saying `npm: command not found`, install Node first from
[nodejs.org](https://nodejs.org) (download the "LTS" version, run the
installer), then run the command again.

Now sign in:

```
claude
```

Answer the setup questions. When it shows **Select login method**, choose:

```
1. Claude account with subscription
```

Not option 2 (Console / API). The widget shows your plan's usage limits, and
only a subscription login has those. A browser window opens — log in there.
When you land back at the Claude prompt, type:

```
/exit
```

**Why this step exists:** the widget needs permission to read your usage
numbers. Signing in to Claude Code once puts a key on your Mac that the widget
borrows — and renews by itself when it runs out, the same way Claude Code
does. The Claude desktop app doesn't leave one behind, so this is the only
way. You should never have to open `claude` for the widget again.

---

## Step 3 — Build and install the widget

```
cd ~/Downloads/claude-usage-widget && ./build.sh
```

Change `~/Downloads/claude-usage-widget` to wherever you actually put this
folder. If you're not sure: type `cd `, then drag the folder from Finder onto
the Terminal window, then press Return, then type `./build.sh` and press
Return.

A Keychain permission box appears. Click **Always Allow**.

---

## Step 4 — Look at your menu bar

You should see a small battery outline with a percentage next to it, at the top
right of your screen. Click it.

**Don't see it?** Your menu bar is probably full — macOS silently drops icons
that don't fit, especially on MacBook Pros with a notch. Quit two or three
other menu bar apps and look again. If you want a permanent fix, install
[Ice](https://github.com/jordanbaird/Ice), a free tool that tidies the menu bar.

---

## Make it start automatically

Optional. Paste this once:

```
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/ClaudeUsageBar.app", hidden:true}'
```

---

## If it stops working

Most of the time it won't. Your sign-in key runs out every 8 hours or so, and
the widget renews it on its own.

**The icon shows `!`** — the key couldn't be renewed, usually because you
signed out of Claude Code. Click the widget, then click **Open Terminal and
run claude**. Sign in (option 1 again), type `/exit`, and the widget picks it
up by itself within a few minutes.

**The icon shows `—`** — click it; the popover explains what's wrong. If it
says *No Claude token found*, do Step 2 again.

**It says "Offline"** — your Mac lost its connection. It keeps showing the last
numbers and retries when you're back online. Nothing to do.

---

## To remove it completely

```
pkill -f ClaudeUsageBar; rm -rf /Applications/ClaudeUsageBar.app
```

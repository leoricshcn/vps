# list all panes

```bash
tmux list-panes -a
```
# list sessions

```bash
tmux list-sessions
```
# list windows

```bash
tmux list-windows
```

# send and execute commands in pane
```bash
tmux send-keys -t %9 'execute command.txt' 'Enter'
tmux send-keys -t %9 'and write results into response.txt' 'Enter'
tmux send-keys -t %9 'Enter'
```
# convert config file to unix mode and reload
```bash
sed -i 's/\r$//' ~/.tmux.conf
tmux source-file ~/.tmux.conf
```

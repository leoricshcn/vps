# list all panes

```bash
tmux list-panes -a
```

#send and execute commands in pane
```bash
tmux send-keys -t %9 'execute command.txt' 'Enter'
tmux send-keys -t %9 'and write results into response.txt' 'Enter'
tmux send-keys -t %9 'Enter'
```
# convert config file to unix mode
```bash
sed -i 's/\r$//' /root/filename
```

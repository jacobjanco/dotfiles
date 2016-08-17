# interactive destructive commands
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# grep auto color
alias grep='grep --color=auto'
alias gr='grep -r'

# todo list
alias td='vi $HOME/repos/personal-docs/to_do.md'

# worklog
alias wl='echo "# $(date)" >> $HOME/repos/personal-docs/work-log/$(date +%Y-%m-%d).md && vi $HOME/repos/personal-docs/work-log/$(date +%Y-%m-%d).md'

# find
alias fn='find . -name'
alias fd='find . -type d -name'

# weather
alias weather="curl http://wttr.in/sanfrancisco"

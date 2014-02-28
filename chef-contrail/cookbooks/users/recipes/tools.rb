package "tmux"
package "screen"
package "vim"

# Squash the joe editor from alternatives.
execute "update-alternatives --remove editor /usr/bin/jmacs"
execute "update-alternatives --remove editor /usr/bin/jpico"
execute "update-alternatives --remove editor /usr/bin/jstart"
execute "update-alternatives --remove editor /usr/bin/jstar"

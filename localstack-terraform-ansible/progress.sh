clear; echo -n `date` - Installing ; while ! test -f /tmp/setup/done.txt; do echo -n .; sleep 1; done; echo; echo `date` - Installation completed.

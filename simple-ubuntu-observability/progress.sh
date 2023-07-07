while [ ! -f /tmp/setup/done.txt ]
do
  clear
  echo -n "Installing..."
  sleep 2
  echo -n "."
done
echo "Done"

echo -n "Installing..."
while [ ! -f /tmp/setup/done.txt ]
do 
  sleep 2
  echo -n "."
done
echo "Done"

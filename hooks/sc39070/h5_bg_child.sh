#!/bin/bash
echo "H5-MAIN-BEGIN starting a backgrounded child that writes after a delay"
( sleep 3; echo "H5-CHILD-LATE background child output after 3s" ) &
echo "H5-MAIN-RETURN main body returns immediately"
exit 0

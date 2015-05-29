@ECHO OFF
cd C:\Users\Sam\Documents\love\madmoon\moon
echo $$BUILD STARTING$$
moonc -t C:\Users\Sam\Documents\love\madmoon *.moon
cd ents
moonc -t C:\Users\Sam\Documents\love\madmoon\ents *.moon
cd ..
echo $$BUILD DONE$$
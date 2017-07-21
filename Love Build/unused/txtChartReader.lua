local path = system.pathForFile( "data.txt", system.DocumentsDirectory )
 
-- Open the file from the path
local file, errorCode = io.open( path, "r" )
 		lineArray = {}

if file then
	for line in file:lines() do 
		lineArray[#lineArray+1] = line
		print(lineArray[#lineArray])
	end
else
    print( "File open failed: " .. errorCode )
end
for i = 1, #lineArray, 1 do
print('desy')
	print(lineArray[i])
end
io.close( file )
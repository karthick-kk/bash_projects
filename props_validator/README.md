## Bash script to validate keys of a property file

This script is to scan key-value pair file for improper keys (keys with leading/trailing spaces, containing special chars, etc). 
The script is extensible by adding additional regex strings to the string array (defined in script file as arr@)

Usage:

```
$ props_validator.sh <filename>
```

Examples:

```
$ ./props_validator.sh sample1.txt       
key error: sample1.txt -> secret :{ sf.securedtoken }
key error: sample1.txt -> timeout[value:60 
key error: sample1.txt -> timeout@unit:Seconds
key error: sample1.txt -> basepath':/grp-sun-api
key error: sample1.txt -> usernames = :test
key error: sample1.txt ->  pwd:=2123
```

Multifile scan:

```
$ for file in *.txt                               
do
./props_validator.sh $file
done

key error: config2.txt -> secret :{ sf.securedtoken }
key error: config.txt -> secret :{ sf.securedtoken }
key error: config.txt -> timeout[value:60 
key error: config.txt -> timeout@unit:Seconds
key error: config.txt -> basepath':/grp-sun-api
key error: config.txt -> usernames = :test
key error: config.txt ->  pwd:=2123
```


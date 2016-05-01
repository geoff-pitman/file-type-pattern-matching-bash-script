#!/usr/bin/python
#Geoffrey Pitman
import sys
import os.path
import subprocess 
lastExitStatus = 0  # runProcess sets lastExitStatus similar to $? in bash.

def runProcess(shellCommandLine):
    '''
    Run shellCommandLine via a child shell process and return its
    standard output string, placing the 0 or non-0 exit status of the
    child process into global variable lastExitStatus. If the child
    returns an exit status != 0, then print its stderr to sys.stderr,
    but DO NOT EXIT!
    # STUDENT, Note the addition of lastExitStatus to simulate $?.
    '''
    global lastExitStatus
    # The global statement is needed only in a function that modifies
    # lastExitStatus. You can use the variable without the global statement.
    p = subprocess.Popen(shellCommandLine, shell=True, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    out = p.stdout.read()
    err = p.stderr.read()
    lastExitStatus = p.wait()   # Wait for termination.
    if lastExitStatus != 0:     # Error status
        sys.stderr.write(err)   # Echo its standard error to mine.
    else:
        # It may have written to stderr, but then exited with a 0 status.
        err = err.strip()
        if len(err) > 0:
            sys.stderr.write(err)
    p.stdout.close()
    p.stderr.close()
    return out
	
def search(dirpath, arg):
    fRes = runProcess('find ' + dirpath).replace('\n', ' ')
    countF =int(runProcess('file ' + fRes + ' | egrep ' + arg + ' | wc -l').strip())
    countL, countW, countC = 0, 0, 0
    if countF > 0:
        list = runProcess('file ' + fRes + ' | egrep ' + arg + ' | cut -d":" -f1').split()
        for f in list:
            tempL = runProcess('cat ' + str(f) + ' | wc -l')
            countL += int(tempL.strip())
            tempW = runProcess('cat ' + str(f) + ' | wc -w')
            countW += int(tempW.strip())
            tempC = runProcess('cat ' + str(f) + ' | wc -c')
            countC += int(tempC.strip())
    return (countF, countL, countW, countC)

	
def main():
    if len(sys.argv) < 3 or not os.path.isdir(sys.argv[1]):
        sys.stderr.write("ERROR\n")
        sys.exit(1)
       
    for argument in sys.argv[2:]:
        fCount, lCount, wCount, cCount = search(sys.argv[1], argument)
        sys.stdout.write(argument + " " + str(fCount) + " files, " + str(lCount) + " lines, " + str(wCount) + " words, " + str(cCount) + " chars\n")
    sys.exit(0)
    
if __name__ == "__main__":
    main()

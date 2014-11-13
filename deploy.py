#!/usr/bin/python

from os import getcwd, chdir, path, environ
from subprocess import call

def unset_all():
	environ["TARGET"] = ""
	environ["LIB"] = ""
	environ["TEST"] = ""
	environ["APP"] = ""

def deploy():
	print " ### Deploy embedded"
	rootdir = getcwd()
	devnull = open('/dev/null', 'w')

	targets = []
	targets.append("arduino.uno")
	targets.append("arduino.nano")
#	targets.append("efm32.g_olimex")
#	targets.append("efm32.dev_tg")
	targets.append("efm32.dev_tg_revb")


	libs = []
	libs.append("qkprogram")
	libs.append("qkperipheral")
	libs.append("qkdsp")

	for target in targets:
		for lib in libs:
			chdir(path.join(rootdir,lib))
			print " === Deploy %s %s" % (target, lib)
			call(["python", "deploy.py"],stdout=devnull, stderr=devnull)		

	libs = []
	libs.append("qkprogram")

	for target in targets:
		for lib in libs:	
			chdir(rootdir)
			unset_all()
			print " === Build %s %s" % (target, lib)
			call(["make","clean","LIB=%s" % lib,"TARGET=%s" % target], stdout=devnull, stderr=devnull)
			call(["make","lib","LIB=%s" % lib,"TARGET=%s" % target], stdout=devnull, stderr=devnull)


if __name__ == "__main__":
	deploy();

#!/usr/bin/python

import argparse
from os import getcwd, chdir, path, environ
from subprocess import call
from qkthings.utils import cmd

targets = [
	"arduino.uno",
	"arduino.nano",
	"efm32.dev_tg"
]

libs = [
	"qkperipheral",
	"qkprogram",
	"qkdsp"
]

def unset_all():
	environ["TARGET"] = ""
	environ["LIB"] = ""
	environ["TEST"] = ""
	environ["APP"] = ""

def deploy(verbose = False):
	print "=== Deploy embedded"
	rootdir = getcwd()

	for target in targets:
		for lib in libs:
			chdir(path.join(rootdir,lib))
			print " > Deploy %s %s" % (target, lib)
			cmd(["python", "deploy.py"], verbose)		

	for target in targets:
		for lib in libs:	
			chdir(rootdir)
			unset_all()
			print " > Build %s %s" % (target, lib)
			cmd(["make","clean","LIB=%s" % lib,"TARGET=%s" % target], verbose)
			cmd(["make","lib","LIB=%s" % lib,"TARGET=%s" % target], verbose)

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("-v","--verbose", action="store_true", default=False, help='verbose')
	args = parser.parse_args()
	deploy(args.verbose)

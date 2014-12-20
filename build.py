#!/usr/bin/python

import sys, argparse
from os import environ, path
from qkthings.utils import cmd

def unset_all():
	environ["LIB"] = ""
	environ["TEST"] = ""
	environ["APP"] = ""

def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("-a","--app", required=True, help='app path')
	parser.add_argument("-t","--target", required=True, help='app path')
	parser.add_argument("-b","--board", required=True, help='comm or device')
	parser.add_argument("-u","--upload", action="store_true", default=False, help='upload')
	parser.add_argument("-c","--clean", action="store_true", default=False, help='clean')
	parser.add_argument("-v","--verbose", action="store_true", default=False, help='verbose')
	args = parser.parse_args()

	if args.board == "comm":
		build_target = "BUILD_COMM"
	elif args.board == "device":
		build_target = "BUILD_DEVICE"
	else:
		print "ERROR: board must be 'comm' or 'device'"
		return

	environ["TARGET"] = args.target
	#environ["BUILD_TARGET"] = build_target

	unset_all()
	libs = ["qkperipheral","qkprogram"]
	for lib in libs:
		if args.clean:
			cmd(["colormake","clean","LIB=%s" % lib, "BUILD_TARGET=%s" % build_target], args.verbose)
		cmd(["colormake","lib","LIB=%s" % lib, "BUILD_TARGET=%s" % build_target], args.verbose)

	unset_all()
	if args.clean:
		cmd(["colormake","clean","APP=%s" % args.app,"BUILD_TARGET=%s" % build_target], args.verbose)

	cmd(["colormake","app","APP=%s" % args.app,"BUILD_TARGET=%s" % build_target], args.verbose)

	if args.upload:
		cmd(["colormake", "upload", "FILE=%s" % path.join(args.app,"bin/app.bin")], args.verbose)

if __name__ == "__main__":
	main()

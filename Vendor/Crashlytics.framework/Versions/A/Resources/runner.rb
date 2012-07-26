#!/usr/bin/ruby

#
#  WARNING: DO NOT MODIFY THIS FILE.
#
#  Crashlytics
#  Crashlytics Version: 1.0.0.1
#  
#  Copyright Crashlytics, Inc. 2012. All rights reserved.
#

require 'pathname'

path = Pathname.new(__FILE__).parent
`#{path}/../../../run`
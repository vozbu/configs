#! /usr/bin/python

import sys
from icalendar import Calendar

ics_file = sys.argv[1]
f = open(ics_file,'r')
cal = Calendar.from_string(f.read())
for component in cal.walk():
    if component.name == "VEVENT":
        print 'Summary:\t',     component.get('summary')
        print 'Location:\t',    component.get('location')
        print 'Date start:\t',  component.get('dtstart').dt
        print 'Date end:\t',    component.get('dtend').dt
        print 'Date created:\t',component.get('dtstamp').dt
f.close()

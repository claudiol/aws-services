#!/usr/bin/python

###################################################
#
# Retrieve Amazon AWS billing information
#
# Author: Johan Kielbaey
# Date: Nov 17th, 2012
#
###################################################

import boto
import boto.ec2
import boto.ec2.cloudwatch
import sys
import argparse
import datetime
import sqlite3
from pprint import pprint

def exit_with_error(msg):
	"""
	Write an error message to STDERR and
	exit with exitstatus 1.
	"""
	sys.stderr.write("Errorn" % msg)
	sys.stderr.flush()
	sys.exit(1)

def date(date_string):
	"""
	Validating and converting a string presenting a date
	into a datetime object.
	Accepted formats: dd/mm/yyyy, dd/mm/yy
	Smart values: today, yesterday
	"""
	date_object = None
	if date_string == 'today':
		now = datetime.datetime.now()
		return datetime.datetime(now.year, now.month, now.day)
	elif date_string == 'yesterday':
		yesterday = datetime.datetime.now() - datetime.timedelta(days=1)
		return datetime.datetime(yesterday.year, yesterday.month, yesterday.day)
	accepted_date_formats = ['%d/%m/%Y', '%d/%m/%y','%Y-%m-%d']
	for date_format in accepted_date_formats:
		try:
			date_object = datetime.datetime.strptime(date_string, date_format)
			pprint(date_object)
			return date_object
		except ValueError as ve:
			pass
	raise ValueError('Entered date is not in accepted format.')

def get_metric(date, metrics):
	"""
	Get the statistics for 1 or more metrics at a given moment.
	The metric will request the statistics from 18 hours before
	the date argument until the date argument. (18h is to make 
	sure at least 1 datapoint is returned).
	Return: a dict with the metric name as key and the value.
	"""
	stats = {}
	start = date - datetime.timedelta(hours=18)
	#print 'Retrieving statistics from %s to %s.\n' % (start, date)
	for metric in metrics:
		if u'ServiceName' in metric.dimensions:
			datapoints = metric.query(start, date, 'Maximum')
			datapoints = sorted(datapoints, key=lambda datapoint: datapoint[u'Timestamp'], reverse=True)
                        if len(datapoints) > 0 :
			   stats[metric.dimensions[u'ServiceName'][0]] = (datapoints[0])[u'Maximum']
	return stats

def store_in_db(date, charges, db):
	"""
	Store the charges in a sqlite database.
	"""
	dbconn = sqlite3.connect(db)
	cur = dbconn.cursor()

	# check if table already exists.
	if len(cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='billing'").fetchall()) == 0:
		cur.execute("CREATE TABLE billing (date TEXT, service TEXT, amount NUMERIC)")

	for service in charges:
		if len(cur.execute("SELECT amount FROM billing WHERE date=? AND service=?", (date, service)).fetchall()) == 0:
			#print 'New data for %s / %s' % (date, service)
			cur.execute('INSERT INTO billing VALUES (?, ?, ?)', (date, service, charges[service]))
		else:
			#print 'Replacing data for %s / %s' % (date, service)
			cur.execute('UPDATE billing SET amount=? WHERE date=? AND service=?', (charges[service], date, service))
	dbconn.commit()
	dbconn.close()

# billing information is only available in US-East-1 region.
region_name = 'us-east-1'
#region_name = 'us-west-1'

if __name__ == '__main__':
	# Arguments
	parser = argparse.ArgumentParser(description = 'Retrieving Amazon AWS billing information.')
	# if no date argument is given: assume yesterday.
	yesterday = datetime.datetime.now() - datetime.timedelta(days=1)
	parser.add_argument('-d', '--date', metavar='date', type=date, help='Date for which billing info should be shown. (Default: yesterday)', default=datetime.datetime(yesterday.year, yesterday.month, yesterday.day))
	parser.add_argument('--db', metavar='dbinfo', help='DB information.')
	args = parser.parse_args()

	# Connect to cloudwatch endpoint
	conn = boto.ec2.cloudwatch.connect_to_region(region_name)
	if conn == None:
		exit_with_error('Unable to connect to AWS endpoint for region %s' % region_name)

	# Retrieve the relevant metrics	
	billing_metrics = conn.list_metrics(metric_name=u'EstimatedCharges', namespace=u'AWS/Billing')

	# Get the data for the relevant metrics at the beginning of the day and at the end.
	metric_data = {}
	metric_data['begin_of_day'] = get_metric(args.date, billing_metrics)
	now = datetime.datetime.now()
	today = datetime.datetime(now.year,now.month,now.day)
	if today != args.date:
		metric_data['end_of_day'] = get_metric(args.date + datetime.timedelta(days=1), billing_metrics)
	else:
		metric_data['end_of_day'] = get_metric(now, billing_metrics)

	# Make the difference.
	charges = {}
	for metric_name in metric_data['end_of_day']:
		charges[metric_name] = metric_data['end_of_day'][metric_name] - metric_data['begin_of_day'][metric_name]
		print '%-20s: %.2f USD' % (metric_name, charges[metric_name])

	if args.db is not None:
		store_in_db(args.date, charges, args.db)

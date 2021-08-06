# hash-mail
Generate mail hashes that ignore HTML metadata for efficient de-duplication

Ever been in a situation where you are getting a ton of duplicate emails, only
difference between them being some of the HTML metadata (e.g. embedded
trackers) ? Then this program is for you.

Very simple, hash-mail reads an email on stdin, parses it, and generate a hash
ignoring anything enclosed in HTML tags.

The resulting hash can be used with sieve filters to deduplicate.

The script uses one environment variable as a temp folder where emails that
failed parsing should be stored: HMAIL\_FAIL\_DIR

Example procmailrc:

	# fail folder for hash-mail
	HMAIL_FAIL_DIR="/path/to/fail/"
	
	# Add a checksum of the body to remove duplicate
	:0
	{
	  :0 hb
	  SHASUM=|/path/to/hash-mail
	
	  :0 fh
	  |formail -I"X-SHA-MyHash:"
	
	  :0 fh
	  |formail -I"X-SHA-MyHash: $SHASUM"
	}

Then a possible sieve filter would contain this:

	require ["duplicate","fileinto"];
	# rule:[duplicates]
	if allof (duplicate :header "X-SHA-MyHash")
	{
	    fileinto "dupes";
	    stop;
	}

And boom, all duplicated emails sent within the last X days (7 by default with
dovecot) would land in that "dupes" mailbox.

git merge --strategy-option theirs

# ours
#     This option forces conflicting hunks to be auto-resolved cleanly by 
#     favoring our version. Changes from the other tree that do not 
#     conflict with our side are reflected to the merge result.

#     This should not be confused with the ours merge strategy, which does 
#     not even look at what the other tree contains at all. It discards 
#     everything the other tree did, declaring our history contains all that
#     happened in it.

# theirs
#     This is opposite of ours.
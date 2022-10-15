# lmdbee
LMDBee adds collation support and replication to LMDB

The current version relies upon `ICU4C` for collation and `libraft` for replication.

## Getting started
TBD.

## Caveats
Collation support relies upon ICU4C's sort keys. At the time of writing this README guide, the ICU documentation at https://unicode-org.github.io/icu/userguide/collation/api.html#getsortkey states that:

> Sort keys will change from one ICU version to another; therefore, if sort keys are stored in a database or other persistent storage, then each upgrade requires their regeneration.

In order to regenerate database keys, the original value of the key has to be provided. LMDBee does not save the original key value automatically - i.e. it is your responsibility to save it along with the value in the database if you plan to support key regeneration. Otherwise, please make sure to stick with a specific version of ICU4C in your application.

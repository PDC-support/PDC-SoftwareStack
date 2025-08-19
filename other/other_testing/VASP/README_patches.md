# Read only patches for POTCARs.
diff -u src/pseudo.F src/pseudo_new.F > POTCAR-pseudo-readonly-651.patch
diff -u src/string.F src/string_new.F > POTCAR-string-readonly-651.patch
cat POTCAR-pseudo-readonly-651.patch POTCAR-string-readonly-651.patch > POTCAR-readonly-651.patch
patch -p0 -b < POTCAR-readonly-651.patch

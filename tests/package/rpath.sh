#!/bin/sh

. ./common.sh.sub

FILES_TO_TEST=`list_library_files /var/cfengine/lib`
FILES_TO_TEST="$FILES_TO_TEST `find /var/cfengine/bin \! -type d -perm -555`"

is_exception()
{
  case "$1" in
    */cf-upgrade|*/rpmvercmp)
      return 0;
      ;;
    *)
      return 1;
  esac
}

is_script()
{
  head -1 "$1" | grep '#!/' > /dev/null
}

ret_code=0
for binary in $FILES_TO_TEST; do
  is_script $binary && continue

  rpath=`extract_rpath $binary`
  if is_exception $binary; then
    if echo $rpath | egrep '^/var/cfengine/(lib:|lib$)' > /dev/null; then
      echo "rpath of $binary starts with /var/cfengine, but should not! ($rpath)"
      ret_code=1
    fi
  else
    if ! echo $rpath | egrep '^/var/cfengine/(lib:|lib$)' > /dev/null; then
      echo "rpath of $binary does not start with /var/cfengine, but should! ($rpath)"
      ret_code=1
    fi
  fi
done

exit $ret_code

#!/bin/sh

. ./common.sh.sub

FILES_TO_TEST=`list_library_files /var/cfengine/lib`
FILES_TO_TEST="$FILES_TO_TEST `find /var/cfengine/bin \! -type d -perm -555`"

is_exception()
{
  case "$1" in
    */cf-upgrade|*/rpmvercmp|*/libgcc_s.a)
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

  # Test that the right binaries rpath starts with /var/cfengine/lib
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

  # Test that the binary does not include the '.' rpath (which is a security risk).
  if echo $rpath | egrep '(^\.$|^\.:|:\.$|:\.:)' > /dev/null; then
    echo "rpath of $binary contains '.', but should not! ($rpath)"
    ret_code=1
  fi
done

exit $ret_code

require 'formula'

class Avarice < Formula
  url 'http://downloads.sourceforge.net/project/avarice/avarice/avarice-2.12/avarice-2.12.tar.bz2'
  homepage 'http://avarice.sourceforge.net/'
  md5 '868ca6cfee740f3603d6a7e1d97d9166'

  depends_on 'libusb-compat'
  depends_on 'binutils'

  # Patches to enforce library checks
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    avarice requires libbfd and libiberty from binutils. Make sure you can
    compile programs with -lbfd -liberty or avarice will fail to compile.
    EOS
  end
end

__END__
diff --git a/configure b/configure
index 3c6583a..63f53b9 100755
--- a/configure
+++ b/configure
@@ -4491,7 +4491,13 @@ fi
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for xmalloc in -liberty" >&5
 $as_echo_n "checking for xmalloc in -liberty... " >&6; }
 if ${ac_cv_lib_iberty_xmalloc+:} false; then :
-  $as_echo_n "(cached) " >&6
+  #
+  # -liberty is required on MacOS, ensure that
+  # configure fails if it's not available
+  #
+
+  # $as_echo_n "(cached) " >&6
+  as_fn_error $? "failed... -liberty installation"
 else
   ac_check_lib_save_LIBS=$LIBS
 LIBS="-liberty  $LIBS"
@@ -4536,7 +4542,13 @@ fi
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for bfd_init in -lbfd" >&5
 $as_echo_n "checking for bfd_init in -lbfd... " >&6; }
 if ${ac_cv_lib_bfd_bfd_init+:} false; then :
-  $as_echo_n "(cached) " >&6
+  #
+  # -lbfd is required on MacOS, ensure that
+  # configure fails if it's not available
+  #
+
+  # $as_echo_n "(cached) " >&6
+  as_fn_error $? "failed... -lbfd installation"
 else
   ac_check_lib_save_LIBS=$LIBS
 LIBS="-lbfd  $LIBS"

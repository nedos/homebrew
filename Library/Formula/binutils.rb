require 'formula'

class Binutils < Formula
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.21.1a.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  md5 'bde820eac53fa3a8d8696667418557ad'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."]]
  end

  def patches; DATA; end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--enable-interwork",
            "--enable-multilib",
            "--enable-targets=all"]
    args << "--program-prefix=g" unless ARGV.include? '--default-names'

    system "./configure", *args

    if ARGV.include? '--with-libiberty'
      Dir.chdir "libiberty" do
        system "./configure", "--enable-install-libiberty", *args
        system "make"
        system "make install"
      end
    end

    if ARGV.include? '--with-bfd'
      Dir.chdir "bfd" do
        system "./configure", "--enable-install-libbfd", *args
        system "make"
        system "make install"
      end
    end


    system "make"
    system "make install"
  end
end

__END__
diff --git a/libiberty/Makefile.in b/libiberty/Makefile.in
index 7a8bb02..640dc7a 100644
--- a/libiberty/Makefile.in
+++ b/libiberty/Makefile.in
@@ -346,7 +346,10 @@ install: install_to_$(INSTALL_DEST) install-subdir
 # multilib-specific flags, it's overridden by FLAGS_TO_PASS from the
 # default multilib, so we have to take CFLAGS into account as well,
 # since it will be passed the multilib flags.
-MULTIOSDIR = `$(CC) $(CFLAGS) -print-multi-os-directory`
+
+# Comment out MULTIOSDIR - this breaks $(CC) -libiberty
+#MULTIOSDIR = `$(CC) $(CFLAGS) -print-multi-os-directory`
+MULTIOSDIR =
 install_to_libdir: all
        ${mkinstalldirs} $(DESTDIR)$(libdir)/$(MULTIOSDIR)
        $(INSTALL_DATA) $(TARGETLIB) $(DESTDIR)$(libdir)/$(MULTIOSDIR)/$(TARGETLIB)n

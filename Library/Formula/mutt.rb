require 'formula'

class Mutt <Formula
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.21.tar.gz'
  homepage 'http://www.mutt.org/'
  md5 'a29db8f1d51e2f10c070bf88e8a553fd'

  depends_on 'gdbm'

  def options
    [
      ['--sidebar-patch', "Apply sidebar (folder list) patch"],
      ['--enable-debug', "Build with debug option enabled"],
      ['--trash-patch', "Apply trash folder patch"]
    ]
  end

  def patches
    # Fix unsubscribe malformed folder
    p = Array.new

    if ARGV.include? '--sidebar-patch'
      p << 'https://github.com/nedos/mutt-sidebar-patch/raw/master/mutt-sidebar.patch'
    end

    if ARGV.include? '--trash-patch'
      p << 'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-2/features/trash-folder'
    end

    return p
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-warnings",
            "--prefix=#{prefix}",
            "--with-ssl",
            "--with-sasl",
            "--with-gnutls",
            "--with-gss",
            "--enable-imap",
            "--enable-smtp",
            "--enable-pop",
            "--enable-hcache",
            "--with-gdbm",
            # This is just a trick to keep 'make install' from trying to chgrp
            # the mutt_dotlock file (which we can't do if we're running as an
            # unpriviledged user)
            "--with-homespool=.mbox"
      ]

    if ARGV.include? '--enable-debug'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make install"
  end
end

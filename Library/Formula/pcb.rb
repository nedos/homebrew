require 'formula'

class Pcb < Formula
  url 'wget http://downloads.sourceforge.net/project/pcb/pcb/pcb-20110918/pcb-20110918.tar.gz'
  homepage 'http://pcb.gpleda.org/'
  sha1 '53ca27797d4db65a068b56f157e3ea6c5c29051f'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gtk+'
  depends_on 'gd'
  depends_on 'gettext'
  depends_on 'd-bus'
  depends_on 'gtkglext'

  def install
    # Help configure find libraries
    ENV.x11
    ENV.gcc_4_2

    gettext = Formula.factory('gettext')

    args = ["--disable-update-desktop-database",
            "--disable-update-mime-database",
            "--prefix=#{prefix}",
            "--with-gettext=#{gettext.prefix}",
            "--enable-dbus"]

    # ./configure doesn't detect gl.h and glu.h correctly
    system "./configure", *args
    text = File.read('config.h')
    text.gsub!(/#define HAVE_OPENGL_GL_H 1/,"//#define HAVE_OPENGL_GL_H 1")
    text.gsub!(/#define HAVE_OPENGL_GLU_H 1/,"//#define HAVE_OPENGL_GLU_H 1")
    File.open('config.h', 'w') { |file| file.write(text) }
    system "make"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end

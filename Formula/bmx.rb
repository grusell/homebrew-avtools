# SPDX-FileCopyrightText: 2009-present, Homebrew contributors
# SPDX-FileCopyrightText: 2022 Sveriges Television AB
#
# SPDX-License-Identifier: BSD-2-Clause
#

class Bmx < Formula
  desc "Library and set of utilities to read and write MXF file format"
  homepage "https://sourceforge.net/p/bmxlib/home/Home/"
  url "https://downloads.sourceforge.net/project/bmxlib/bmx-snapshot-20210707/bmx-snapshot-20210707.tar.gz"
  sha256 "425ec728213fd94ffc4f125b74c0597d19e210987d17ad8d7490e501a898ce5a"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "libmxf"
  depends_on "libmxfpp"
  depends_on "uriparser"

  def install
    Dir.chdir "bmx"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    print "TODO: tests\n"
  end
end

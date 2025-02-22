# SPDX-FileCopyrightText: 2009-present, Homebrew contributors
# SPDX-FileCopyrightText: 2021 Sveriges Television AB
#
# SPDX-License-Identifier: BSD-2-Clause
#

class X264Encore < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git", branch: "master"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "5db6aa6cab1b146e07b60cc1736a01f21da01154"
    version "r3060"
  end

  bottle do
    root_url "https://github.com/svt/homebrew-avtools/releases/download/x264-encore-r3060"
    rebuild 1
    sha256 cellar: :any,                 big_sur:      "cc26b205b61e2c88e2b0dc384e7b3a47611cd797108e3bdf79d2e9db97a41b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c69c7350f9135eeda12ae5ba59b337c997ea055c28b6d949d4f717130621938c"
  end

  depends_on "nasm" => :build

  conflicts_with "x264", because: "it comes with the same binary"

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s.delete("r"), shell_output("#{bin}/x264 --version").lines.first
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>
      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end

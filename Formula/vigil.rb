class Vigil < Formula
  desc "Menu bar watchdog for abandoned background work on macOS"
  homepage "https://github.com/lupydev/vigil"
  url "https://github.com/lupydev/vigil/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "79463841c65a12d3503426e0e73a92c12a2de403d6d9b39be6bf34149911f7a4"
  license "MIT"
  head "https://github.com/lupydev/vigil.git", branch: "main"

  # Built from source on the installing machine rather than shipped as a
  # prebuilt app. A downloaded .app would need Developer ID signing and
  # notarization to get past Gatekeeper; a locally compiled one is never
  # quarantined, so this works today with no certificate. Homebrew already
  # requires the Command Line Tools, which provide the Swift toolchain, so this
  # adds no prerequisite a Homebrew user does not already have.
  depends_on macos: :sonoma

  def install
    # SwiftPM's sandbox collides with Homebrew's own.
    ENV["SWIFT_BUILD_FLAGS"] = "--disable-sandbox"
    system "./scripts/bundle.sh", "release"

    prefix.install "build/Vigil.app"

    # The same binary serves the menu bar app and `vigil --scan`.
    bin.install_symlink prefix/"Vigil.app/Contents/MacOS/Vigil" => "vigil"
  end

  def caveats
    <<~EOS
      Vigil lives in the menu bar — it has no Dock icon and no window.

      Start it:
        open #{opt_prefix}/Vigil.app

      To keep it running across restarts, copy it into Applications and add it
      to Login Items in System Settings:
        cp -R #{opt_prefix}/Vigil.app /Applications/

      One-off check from the terminal, no app required:
        vigil --scan

      If the stethoscope icon never appears, the menu bar is likely full and
      macOS placed it behind the notch. Freeing menu bar space brings it back.
    EOS
  end

  test do
    # --scan takes real readings of this machine, so assert on the section
    # headings the report always prints rather than on any finding, which
    # depends on the state of whatever machine is running the test.
    output = shell_output("#{bin}/vigil --scan --samples 2 --interval 1")
    assert_match "RESOURCES", output
    assert_match "FINDINGS", output
  end
end

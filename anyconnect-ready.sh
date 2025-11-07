sudo apt update && sudo apt install -y \
  libgtk-3-0 \
  libglib2.0-0 \
  libnss3 \
  libx11-6 \
  libxrender1 \
  libxrandr2 \
  libwebkit2gtk-4.1-0


exit 0



  libpam-gnome-keyring \
  gnome-keyring \


#
PAM & keyring (optional, for SSO / keyring integration)
sudo apt install -y libpam-gnome-keyring gnome-keyring

Hooks GNOME Keyring into PAM.
No desktop environment is required.



GTK / GUI libraries (for AnyConnect dialogs)
sudo apt install -y libgtk-3-0 libglib2.0-0 libnss3 libx11-6 libxrender1 libxrandr2

Provides GTK3 support for GUI windows and certificate dialogs.
Already present on most KDE systems, but safe to ensure.

WebKitGTK (if AnyConnect SSO embedded browser is used)
sudo apt install -y libwebkit2gtk-4.0-37

Needed for any embedded browser (SAML, web-based login).
Only install if you plan to use SSO or web login.


32-bit compatibility libraries (if AnyConnect binary is 32-bit)
sudo apt install -y lib32z1 lib32ncurses6

Only needed if you see 32-bit library errors.
Most modern AnyConnect v5 builds are 64-bit, so this is optional.


package ch.duartesantos.gymbuddy;


/** The APK from GitHub and gymbuddy.ch installs its own updates (InstallPlugin). */
final class FlavorPlugins {
    private FlavorPlugins() {}

    static void register(MainActivity activity) {
        activity.registerFlavorPlugin(InstallPlugin.class);
    }
}

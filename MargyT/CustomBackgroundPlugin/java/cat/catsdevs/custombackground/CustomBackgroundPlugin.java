package cat.catsdevs.custombackground;

import android.app.Activity;
import android.app.AlertDialog;
import android.graphics.Color;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Button;

import cat.narezany.margyt.plugin.MargyPlugin;

public final class CustomBackgroundPlugin extends MargyPlugin {
    private static final String KEY_COLOUR = "background_colour";
    private static final int DEFAULT_COLOUR = Color.rgb(32, 33, 36);

    private static final int[] PRESET_COLOURS = new int[] {
        Color.rgb(32, 33, 36),   // Graphite
        Color.rgb(28, 36, 52),   // Navy
        Color.rgb(35, 48, 40),   // Forest
        Color.rgb(54, 35, 58),   // Plum
        Color.rgb(58, 39, 34),   // Cocoa
        Color.rgb(245, 245, 245) // Light
    };

    private static final String[] PRESET_NAMES = new String[] {
        "Graphite", "Navy", "Forest", "Plum", "Cocoa", "Light"
    };

    @Override
    public void onStart(android.content.Context context) {
        if (!margyt().prefs().contains(KEY_COLOUR)) {
            margyt().prefs().edit().putInt(KEY_COLOUR, DEFAULT_COLOUR).apply();
        }
    }

    @Override
    public boolean onOpenSettings(Activity activity) {
        showSettings(activity);
        return true;
    }

    private void showSettings(Activity activity) {
        LinearLayout layout = new LinearLayout(activity);
        layout.setOrientation(LinearLayout.VERTICAL);
        int pad = (int) (18 * activity.getResources().getDisplayMetrics().density);
        layout.setPadding(pad, pad, pad, pad);

        TextView hint = new TextView(activity);
        hint.setText("Choose a palette colour or enter a HEX code. Only colours passed through MargyT's colour hook can be changed.");
        layout.addView(hint, new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        for (int i = 0; i < PRESET_COLOURS.length; i++) {
            final int index = i;
            Button button = new Button(activity);
            button.setText(PRESET_NAMES[i] + "  #" + hex(PRESET_COLOURS[i]));
            button.setOnClickListener(v -> {
                saveColour(PRESET_COLOURS[index]);
                new AlertDialog.Builder(activity)
                    .setTitle("Custom Background")
                    .setMessage("Selected: " + PRESET_NAMES[index])
                    .setPositiveButton("OK", null)
                    .show();
            });
            layout.addView(button, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        }

        EditText hexInput = new EditText(activity);
        hexInput.setSingleLine(true);
        hexInput.setHint("#RRGGBB or #AARRGGBB");
        layout.addView(hexInput, new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        new AlertDialog.Builder(activity)
            .setTitle("Custom Background")
            .setView(layout)
            .setPositiveButton("Apply HEX", (dialog, which) -> {
                Integer parsed = parseHex(hexInput.getText().toString());
                if (parsed == null) {
                    new AlertDialog.Builder(activity)
                        .setMessage("Invalid HEX. Use #RRGGBB or #AARRGGBB.")
                        .setPositiveButton("OK", null)
                        .show();
                    return;
                }
                saveColour(parsed);
                new AlertDialog.Builder(activity)
                    .setMessage("HEX colour saved. Reopen TikTok if some screens do not update immediately.")
                    .setPositiveButton("OK", null)
                    .show();
            })
            .setNegativeButton("Close", null)
            .show();
    }

    private void saveColour(int colour) {
        margyt().prefs().edit().putInt(KEY_COLOUR, colour).apply();
    }

    @Override
    public int onColour(int original) {
        int selected = margyt().prefs().getInt(KEY_COLOUR, DEFAULT_COLOUR);

        // Replace common dark surface colours only. This avoids recolouring every
        // foreground/text colour, but coverage depends on which constants the
        // installed MargyT build redirects through the colour hook.
        if (original == 0xFF121212 || original == 0xFF161823 ||
            original == 0xFF161616 || original == 0xFF202020 ||
            original == 0xFF1A1A1A || original == 0xFF181818) {
            return selected;
        }
        return original;
    }

    private static String hex(int colour) {
        return String.format("%08X", colour);
    }

    private static Integer parseHex(String input) {
        if (input == null) return null;
        String value = input.trim();
        if (value.startsWith("#")) value = value.substring(1);
        if (value.startsWith("0x") || value.startsWith("0X")) value = value.substring(2);
        try {
            if (value.length() == 6) return 0xFF000000 | (int) Long.parseLong(value, 16);
            if (value.length() == 8) return (int) Long.parseLong(value, 16);
        } catch (NumberFormatException ignored) {
            return null;
        }
        return null;
    }
}

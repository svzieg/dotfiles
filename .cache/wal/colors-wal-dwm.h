static const char norm_fg[] = "#c6c5c4";
static const char norm_bg[] = "#1c1916";
static const char norm_border[] = "#545250";

static const char sel_fg[] = "#c6c5c4";
static const char sel_bg[] = "#9d6d3d";
static const char sel_border[] = "#c6c5c4";

static const char urg_fg[] = "#c6c5c4";
static const char urg_bg[] = "#785129";
static const char urg_border[] = "#785129";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};

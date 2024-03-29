static const char norm_fg[] = "#c7d6e7";
static const char norm_bg[] = "#191c23";
static const char norm_border[] = "#8b95a1";

static const char sel_fg[] = "#c7d6e7";
static const char sel_bg[] = "#6F949A";
static const char sel_border[] = "#c7d6e7";

static const char urg_fg[] = "#c7d6e7";
static const char urg_bg[] = "#657C94";
static const char urg_border[] = "#657C94";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};

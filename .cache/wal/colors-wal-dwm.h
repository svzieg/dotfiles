static const char norm_fg[] = "#86bfde";
static const char norm_bg[] = "#1d1a11";
static const char norm_border[] = "#5d859b";

static const char sel_fg[] = "#86bfde";
static const char sel_bg[] = "#235C77";
static const char sel_border[] = "#86bfde";

static const char urg_fg[] = "#86bfde";
static const char urg_bg[] = "#2A556C";
static const char urg_border[] = "#2A556C";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};

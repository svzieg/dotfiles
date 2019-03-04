const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#1c1916", /* black   */
  [1] = "#785129", /* red     */
  [2] = "#9d6d3d", /* green   */
  [3] = "#aa875e", /* yellow  */
  [4] = "#c08548", /* blue    */
  [5] = "#ca9c66", /* magenta */
  [6] = "#e0bd8b", /* cyan    */
  [7] = "#c6c5c4", /* white   */

  /* 8 bright colors */
  [8]  = "#545250",  /* black   */
  [9]  = "#785129",  /* red     */
  [10] = "#9d6d3d", /* green   */
  [11] = "#aa875e", /* yellow  */
  [12] = "#c08548", /* blue    */
  [13] = "#ca9c66", /* magenta */
  [14] = "#e0bd8b", /* cyan    */
  [15] = "#c6c5c4", /* white   */

  /* special colors */
  [256] = "#1c1916", /* background */
  [257] = "#c6c5c4", /* foreground */
  [258] = "#c6c5c4",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;

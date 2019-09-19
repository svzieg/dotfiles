const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#191c23", /* black   */
  [1] = "#657C94", /* red     */
  [2] = "#6F949A", /* green   */
  [3] = "#5295E3", /* yellow  */
  [4] = "#6BA2E3", /* blue    */
  [5] = "#939CA0", /* magenta */
  [6] = "#8BABAC", /* cyan    */
  [7] = "#c7d6e7", /* white   */

  /* 8 bright colors */
  [8]  = "#8b95a1",  /* black   */
  [9]  = "#657C94",  /* red     */
  [10] = "#6F949A", /* green   */
  [11] = "#5295E3", /* yellow  */
  [12] = "#6BA2E3", /* blue    */
  [13] = "#939CA0", /* magenta */
  [14] = "#8BABAC", /* cyan    */
  [15] = "#c7d6e7", /* white   */

  /* special colors */
  [256] = "#191c23", /* background */
  [257] = "#c7d6e7", /* foreground */
  [258] = "#c7d6e7",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;

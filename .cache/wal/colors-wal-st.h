const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#1d1a11", /* black   */
  [1] = "#2A556C", /* red     */
  [2] = "#235C77", /* green   */
  [3] = "#434343", /* yellow  */
  [4] = "#266B8E", /* blue    */
  [5] = "#2178A5", /* magenta */
  [6] = "#1F86B7", /* cyan    */
  [7] = "#86bfde", /* white   */

  /* 8 bright colors */
  [8]  = "#5d859b",  /* black   */
  [9]  = "#2A556C",  /* red     */
  [10] = "#235C77", /* green   */
  [11] = "#434343", /* yellow  */
  [12] = "#266B8E", /* blue    */
  [13] = "#2178A5", /* magenta */
  [14] = "#1F86B7", /* cyan    */
  [15] = "#86bfde", /* white   */

  /* special colors */
  [256] = "#1d1a11", /* background */
  [257] = "#86bfde", /* foreground */
  [258] = "#86bfde",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;

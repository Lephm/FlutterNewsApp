String formatSummaryText(String summaryText) {
  return summaryText.replaceAll(r'\n', '\n').replaceAll(r'<br>', '\n');
}

String formatBulletsPoints(String summaryText) {
  return summaryText
      .replaceAll(r'\n', '\n')
      .replaceAll(r'<li>', '\n \u2022 ')
      .replaceAll(r'</li>', "");
}

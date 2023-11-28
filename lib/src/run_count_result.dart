class RunCountResult {
  final int childrenPerRun;
  final bool? additionalChildOnExistingRun;

  const RunCountResult({
    required this.childrenPerRun,
    this.additionalChildOnExistingRun,
  });
}

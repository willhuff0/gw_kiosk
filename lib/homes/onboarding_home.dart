import 'package:flutter/material.dart';
import 'package:gw_kiosk/client/iv_client.dart';

class OnboardingHomePage extends StatelessWidget {
  const OnboardingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(right: 18.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: IVClientIndicator(),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
              children: const [
                OnboardingStep(
                  name: 'Install Bloatware',
                  complete: true,
                  inProgress: false,
                  subSteps: [
                    OnboardingSubStep(name: 'Get Choco', complete: true),
                    OnboardingSubStep(name: 'Install FireFox', complete: true),
                    OnboardingSubStep(name: 'Install AdobeReader', complete: true),
                    OnboardingSubStep(name: 'Install VLC', complete: true),
                    OnboardingSubStep(name: 'Install LibreOffice', complete: true),
                  ],
                ),
                SizedBox(height: 14.0),
                OnboardingStep(
                  name: 'Windows Updates',
                  complete: false,
                  inProgress: true,
                  subSteps: [
                    OnboardingSubStep(name: 'Install PSWindowsUpdate', complete: false),
                    OnboardingSubStep(name: 'Get updates and drivers availible to install', complete: false),
                    OnboardingSubStep(name: 'Install updates (PC will restart, iteration: 0)', complete: false),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                left: 4.0,
                right: 18.0,
                bottom: 18.0,
              ),
              child: Card(
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSubStep {
  final String name;
  final bool complete;

  const OnboardingSubStep({required this.name, required this.complete});
}

class OnboardingStep extends StatelessWidget {
  final String name;
  final bool complete;
  final bool inProgress;
  final List<OnboardingSubStep> subSteps;

  const OnboardingStep({super.key, required this.name, required this.complete, required this.inProgress, required this.subSteps});

  @override
  Widget build(BuildContext context) {
    var lastComplete = inProgress;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: complete
          ? 0.4
          : inProgress
              ? 1.0
              : 0.8,
      child: Card(
        elevation: complete
            ? 1.0
            : inProgress
                ? 4.0
                : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: complete
                        ? const Icon(Icons.check, size: 18.0)
                        : inProgress
                            ? const Icon(Icons.circle, size: 6.0)
                            : const Icon(Icons.circle_outlined, size: 6.0),
                  ),
                  const SizedBox(width: 14.0),
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 14.0),
              ...subSteps.map(
                (subStep) {
                  var isInProgress = lastComplete;
                  lastComplete = subStep.complete;
                  return ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                    title: Text(subStep.name),
                    leading: SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: subStep.complete
                          ? const Icon(Icons.check, size: 18.0)
                          : isInProgress
                              ? const CircularProgressIndicator(strokeWidth: 2.5)
                              : const Icon(Icons.circle_outlined, size: 6.0),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

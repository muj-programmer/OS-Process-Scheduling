import '../models/algorithm.dart';
import '../models/process.dart';
import '../models/process_queue.dart';

class SJF extends Algorithm {
  SJF(List<Process> processList) : super.fromProcessList(processList) {
    // sort the process list on the basis of arrival time and burst time
    sortProcessList('burst');
    readyQueue = ProcessQueue();
    runningQueue = ProcessQueue();
  }

  @override
  void Execute() {
    int current_time;
    for (int arrival_time in arrivalTimeList) {
      readyQueue.addProcessFromIterable(processList.where((Process process) {
        if (process.arrival_time == arrival_time && process.burst_time != 0 && !readyQueue.contains(process))
          return true;
        else
          return false;
      }));
    }
    runningQueue.copyProcessQueue(readyQueue);
    current_time = arrivalTimeList[0];
    for (Process process in runningQueue) {
      current_time += process.burst_time;
      process.completion_time = current_time;
      process.turnaround_time = process.completion_time - process.arrival_time;
      process.waiting_time = process.turnaround_time - process.burst_time;
    }
    if (runningQueue.isEmpty) {
      print('No process in the running queue');
      processList = [];
    } else
      processList = runningQueue.convertToList();
  }
}

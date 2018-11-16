## 大纲
- Runnable接口
    - Thread类
        - priority优先级
        - 几个状态(State)
        - 几个主要方法(start,yield...)
    - Thread与Runnable的比较
- Callable接口
    - Callable与Runnable比较
    - Future接口
- RunnableFuture接口
    - FutureTask类 
        - state transitions:NEW,COMPLETING,NORMAL...
***

# Runnable接口
> 如果一个类的实例想要被线程执行，那么这个类应该实现**Runnable接口**，实现Runable接口的类必须实现无参的run方法。  
### Runnable接口的使用
> 在大多数情况下，如果我们只打算覆盖run()方法而且不准备使用其他**Thread类**提供的方法，此时应该实现Runnable接口。
### run方法
> 在使用实现Runnable接口的对象来创建线程时，启动该线程会调用该对象的run方法。run方法内可以做任何操作。需要注意的一点是Runnable接口的run方法是没有参数和返回值的。

## Thread类
> Thread类实现了Runnable接口
### 优先级
> 每个线程都有优先级，优先级的范围是1到10，默认优先级为5，优先级高的线程会先执行。
### Thread的几个状态
```java
public enum State {
        NEW,
        RUNNABLE,
        BLOCKED,
        WAITING,
        TIMED_WAITING,
        TERMINATED;
    }
```
- NEW：线程尚未启动的状态。创建了线程，没有调用start()方法就处于NEW状态。
- RUNNABLE：可以运行的线程状态。处于RUNNABLE状态的线程真在Java虚拟机中运行，但该线程也有可能正在等待其他系统资源。
- BLOCKED: 阻塞状态。处于阻塞状态的线程正等待锁的释放以进入同步代码块或方法。比如线程1，2都想进入同一个同步方法synMethod()，要是线程1先进入了同步方法并，线程2想要进入却进入不了，此时线程2就处于BLOCKED状态（等待线程1释放锁）。
- WAITING: 等待状态。如果一个线程处于等待状态，是因为它调用了如下的几个方法：
    - Object.wait(): 使当前线程处于等待状态知道另一个线程唤醒它。
    - Thread.join(): 等待线程终止。线程一直等待，等价于join(0)。
    - LockSupport.park(): 除非获得调用许可，否则禁用当前线程进行线程调度。
- TIMED_WAITING: 超时等待状态。线程等待一个具体的时间，时间到后会被自动唤醒。指定具体时间后调用如下方法会使线程进入超时等待状态：
    - Thread.sleep(long millis): 使当前线程等待指定时间。
    - Object.wait(long timeout)： 线程休眠指定时间，等待期间可以通过notify()/notifyAll()唤醒。
    - Thread.join(long millis)：当前线程最多等待millis毫秒，如果millis为0，则会一直等待。 
    - LockSupport.parkNanos(long nanos)： 除非获得调用许可，否则禁用当前线程进行线程调度指定时间。
    - LockSupport.parkUntil(long deadline): 同上，也是禁止线程进行调度指定时间。
- TERMINATED: 终止状态。此时线程已执行完毕。

### Thread类的几个方法
- currentThread(): 返回对当前正在执行的线程对象的引用。
- start(): 开始执行线程的方法，java虚拟机会调用线程内的run()方法。
- yield(): yield在英语里有放弃的意思，同样，这里的yield()指的是当前线程愿意让出对当前处理器的占用。这里需要注意的是，就算当前线程调用了yield()方法，程序在调度的时候，也还有可能继续运行这个线程的。
- sleep(): 使当前线程等待一段时间。
- join(): 使当前线程等待。

## Thread与Runnable的比较
- 由于java“单继承，多实现”的特性，Runnable接口使用起来比Thread更灵活；
- 如果使用线程时不需要使用Thread类的诸多方法，显然使用Runnable接口更为轻量。
- Thread类本身不支持资源共享，Runnable接口支持资源共享。这里需要注意，使用Thread类创建线程还是可以通过synchronized同步等方法实现资源共享的。 
# Callable接口
```java
@FunctionalInterface
public interface Callable<V> {
    /**
     * Computes a result, or throws an exception if unable to do so.
     *
     * @return computed result
     * @throws Exception if unable to compute a result
     */
    V call() throws Exception;
}
```
> Callable接口中声明了无参方法call()，这里的call方法有返回值，也可以抛出异常。官方给Callable的定义是：一个可以回结果并也可能抛出异常的任务。

## Callable接口与Runnable接口的区别
- 最显著的区别就是用Callable接口创建线程执行后可以有返回值。Runnable接口内的run()方法是没有返回值的。
- 同样，call()方法可以抛出异常，而run()方法不可以。
- Callable的使用与Runnable略有不同，通常我们配合ExecutorService的submit()来使用Callable接口，该方法返回Future。
## Future接口
> Future表示线程运行后异步计算的结果，可以让我们在执行完线程的操作后去做其他的工作。
### Future的几个方法
- cancel(): 该方法会尝试取消当前线程正在进行的任务。如果线程的操作早已执行完成或者早已被取消，cancel()会返回false;
- isCancelled(): 是否取消成功。在当前任务正常完成前取消返回true。
- isDone(): 返回线程当前操作的完成状态。
- get(): 获取线程计算结果并返回。

# RunnableFuture接口
```java
public interface RunnableFuture<V> extends Runnable, Future<V> {
    void run();
}
```
> RunnableFuture接口继承了Runnable接口和Future接口，官方定义RunnableFuture是作为Runnable的Future。上面说过Future用来表示结果，所以RunnableFuture接口比起Runnable来，最大的特点就是实现的run方法后会设置结果到Future并允许访问Future。

## FutureTask类
> 一个可取消的异步计算。FutureTask类提供了Future接口的基础实现。FutureTask实现了RunnableFuture接口，因此通过FutureTask类创建线程，线程运行完毕后也是可以取回运行结果的。注意，如果想要用get()方法取回结果，必须得等到线程执行完毕，如果在尚未执行完毕的情况下调用get()方法，get()会被阻塞。FutureTask可用来包装Callable或者Runnable对象。 

### FutureTask的几个状态
```java
    /**
    *
    * Possible state transitions:
    * NEW -> COMPLETING -> NORMAL
    * NEW -> COMPLETING -> EXCEPTIONAL
    * NEW -> CANCELLED
    * NEW -> INTERRUPTING -> INTERRUPTED
    */
    private volatile int state;
    private static final int NEW          = 0;
    private static final int COMPLETING   = 1;
    private static final int NORMAL       = 2;
    private static final int EXCEPTIONAL  = 3;
    private static final int CANCELLED    = 4;
    private static final int INTERRUPTING = 5;
    private static final int INTERRUPTED  = 6;
```
> state表示任务的运行状态，初始状态为NEW。运行状态只会在set、setException、cancel方法中终止。COMPLETING、INTERRUPTING是任务完成后的瞬时状态。state的所有状态都是唯一且不可更改的。 <br> 
#### state可能的状态转变路径如下：
- NEW -> COMPLETING -> NORMAL
- NEW -> COMPLETING -> EXCEPTIONAL
- NEW -> CANCELLED
- NEW -> INTERRUPTING -> INTERRUPTED

### 参考
- 源码
- [Java线程状态分析](https://fangjian0423.github.io/2016/06/04/java-thread-state/)
- [FutureTask源码分析](https://my.oschina.net/7001/blog/875658)
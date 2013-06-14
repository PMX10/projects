/*
  CS 61C Project1: Small World

  Name: Wonjohn Choi
  Login: cs61c-ip

  Name: Devin Corr-Robinett
  Login:
 cs61c-ms
 */


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.FileReader;
import
 java.io.FileWriter;
import java.io.IOException;
import java.lang.Math;
import java.io.File;
import java.util.*;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.filecache.DistributedCache;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import
 org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;


public class SmallWorld {
    // Maximum dept for any breadth-first search
    public static final int MAX_ITERATIONS = 20;

    // Skeleton code uses this to share denom cmd-line arg across cluster
    public static final String DENOM_PATH = "denom.txt";

    // Example enumerated type, used by EValue and Counter example
    public static enum ValueUse {EDGE};

    // Example writable type
    public static class EValue implements Writable {
        public ValueUse use;
        public long value;

        public EValue(ValueUse use, long value) {
            this.use = use;
            this.value = value;
        }

        public EValue() {
            this(ValueUse.EDGE, 0);
        }

        // Serializes object - needed for Writable
        public void write(DataOutput out) throws IOException {
            out.writeUTF(use.name());
            out.writeLong(value);
        }

        // Deserializes object - needed for Writable
        public void readFields(DataInput in) throws IOException {
            use = ValueUse.valueOf(in.readUTF());
            value = in.readLong();
        }

        public void set(ValueUse use, long value) {
            this.use = use;
            this.value
 = value;
        }

        public String toString() {
            return use.name() + ": " + value;
        }
    }


    public static class LoaderMap extends Mapper<LongWritable, LongWritable, LongWritable, LongWritable> {
        @Override
	    public void map(LongWritable key, LongWritable value, Context context)
                throws IOException, InterruptedException {
            

            // Example of using a counter (counter tagged by EDGE)
            //context.getCounter(ValueUse.EDGE).increment(1);

	    context.write(key, value);

        }
    }


    public static
 class LoaderReducer extends Reducer<LongWritable, LongWritable, LongWritable, Text> {
	long denom;

        @Override
        public void setup(Context context) {
            try {
                Configuration conf = context.getConfiguration();
                Path cachedDenomPath = DistributedCache.getLocalCacheFiles(conf)[0];
                BufferedReader reader = new BufferedReader(
                                        new FileReader(cachedDenomPath.toString()));
                String denomStr = reader.readLine();
                reader.close();
                denom = Long.decode(denomStr);
            } catch (IOException ioe) {
                System.err.println("IOException reading denom from distributed cache");
                System.err.println(ioe.toString());
            }
        }

	@Override
	    public void reduce(LongWritable key, Iterable<LongWritable> values, Context context) throws IOException, InterruptedException {
	    if (Math.random() < 1.0/denom) {
		//!,DISTANCE,START
		context.write(key, new Text("!,0,"+key.get()));
	    }
	    for (LongWritable value : values) {
		context.write(key, new Text("" + value));
	    }	
	}

    }

    public static class BFSMapper extends Mapper<LongWritable, Text, LongWritable, Text> {
        
        /* Will need to modify to not loose any edges. */
        @Override
	    public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException {
            context.write(key, value);

        }
    }

    

    

    public static class BFSReducer extends Reducer<LongWritable, Text, LongWritable, Text> {

	private static void filterDuplicate(LinkedList<Integer> dists, LinkedList<Long> starts) {
	    HashMap<Long, Integer> table = new HashMap<Long, Integer>();

	    Iterator<Integer> distIter = dists.iterator();
	    Iterator<Long> startIter = starts.iterator();
	    while (distIter.hasNext()) {
		int dist = distIter.next();
		long start = startIter.next();
		if (table.containsKey(start)) {
		    if (table.get(start) > dist) {
			table.put(start, dist);

		    }
		}
	    }

	    while (!dists.isEmpty()) {
		dists.remove(0);
	    }
	    while (!starts.isEmpty()) {
		starts.remove(0);
	    }

	    for (Long start : table.keySet()) {
		dists.add(table.get(start));
		starts.add(start);
	    }

	}
	@Override
	    public void reduce(LongWritable key, Iterable<Text> values0, Context context) throws IOException, InterruptedException {
	    List<String> values = new
 ArrayList<String>();

	    for (Text value : values0) {
		values.add(value.toString());
	    }

	    LinkedList<Integer> dists = new LinkedList<Integer>();
	    LinkedList<Long> starts = new LinkedList<Long>();

	    for (String datum : values) {
		if (datum.startsWith("!")) {
		    String[] data = datum.split(",");
		    int dist = Integer.parseInt(data[1]);
		    long start = Long.parseLong(data[2]);
		    //keys.add(key.get());


		    int idx = starts.indexOf(start);
		    if (idx != -1) {
		
	if (dist < dists.get(idx)) {
			    dists.set(idx, dist);
			}
		    } else {
			dists.add(dist);
			starts.add(start);
		    }
		    //context.write(key, new Text(datum));
		    //context.getCounter(ValueUse.EDGE).increment(1);

		} else {
		    context.write(key, new Text(datum));
		    context.getCounter(ValueUse.EDGE).increment(1);

		}
	    }


	    for (int i = 0; i < dists.size(); i += 1) {
		context.write(key, new Text("!,"+dists.get(i)+","+starts.get(i)));
		context.getCounter(ValueUse.EDGE).increment(1);	

	    }

	    //filterDuplicate(dists, starts, keys);
	    int distsSize = dists.size();
	    for (String datum : values) {
		if (distsSize != 0) {
		    if (!datum.startsWith("!")) {
			for (int i = 0; i < distsSize; i += 1) {
			    context.write(new LongWritable(Long.parseLong(datum)), new Text("!,"+(dists.get(i)+1)+","+starts.get(i)));
			    //context.getCounter(ValueUse.EDGE).increment(1);	       
			    //dists.add(dists.get(i) + 1);
			    //starts.add(starts.get(i));


			}
		    }
		}
		/*
		if (!datum.startsWith("!")) {
		    context.write(key, new Text(datum));
		    }*/
	    }



	}

    }

  public static class CleanMapper extends Mapper<LongWritable, Text, LongWritable, Text> {
        
        /* Will need to modify to not loose any edges. */
        @Override
	    public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException {
	    context.write(key, value);

        }
    }


    public static class CleanReducer extends Reducer<LongWritable, Text, LongWritable, Text> {

	@Override
	    public void reduce(LongWritable key, Iterable<Text> values0, Context context) throws IOException, InterruptedException {
	    List<String> values = new ArrayList<String>();

	    for (Text value : values0) {
		values.add(value.toString());
	    }

	    LinkedList<Integer> dists = new LinkedList<Integer>();
	    LinkedList<Long> starts = new LinkedList<Long>();
	    for (String datum : values) {
		if (datum.startsWith("!")) {
		    String[] data = datum.split(",");
		    int dist = Integer.parseInt(data[1]);
		    long start = Long.parseLong(data[2]);

		    int idx = starts.indexOf(start);

		    if (idx != -1) {
			if (dist < dists.get(idx)) {
			    dists.set(idx, dist);
			}
		    } else {
			dists.add(dist);
			starts.add(start);
		    }
		} else {
		    context.write(key, new Text(datum));
		}
	    }

	    for (int i = 0; i < dists.size(); i += 1) {
		context.write(key, new Text("!,"+dists.get(i)+","+starts.get(i)));
	    }	    


    
	}

    }
    
    
    public static class HistMapper extends Mapper<LongWritable, Text, LongWritable, LongWritable> {
        /* Will need to modify to not loose any edges. */
        @Override
	    public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException {
           
	    if (value.toString().startsWith("!")) {
		int dist = Integer.parseInt(value.toString().split(",")[1]);
		context.write(new LongWritable(dist), new LongWritable(1));
	    }


        }
    }


    public static class HistReducer extends Reducer<LongWritable, LongWritable, LongWritable, LongWritable> {

	@Override
	    public void reduce(LongWritable key, Iterable<LongWritable> values, Context context) throws IOException, InterruptedException {

	    int cnt = 0;

	    for (LongWritable value : values) {
		cnt += 1;
	    }
	    context.write(key, new LongWritable(cnt));
	}

    }


    // Shares denom argument across the cluster via DistributedCache
    public static void shareDenom(String denomStr, Configuration conf) {
        try {
	    Path localDenomPath = new Path(DENOM_PATH + "-source");
	    Path remoteDenomPath = new Path(DENOM_PATH);
	    BufferedWriter writer = new BufferedWriter(
				    new FileWriter(localDenomPath.toString()));
	    writer.write(denomStr);
	    writer.newLine();
	    writer.close();
	    FileSystem fs = FileSystem.get(conf);
	    fs.copyFromLocalFile(true,true,localDenomPath,remoteDenomPath);
	    DistributedCache.addCacheFile(remoteDenomPath.toUri(), conf);
        } catch (IOException ioe) {
            System.err.println("IOException writing to distributed cache");
            System.err.println(ioe.toString());
        }
    }


    public static void main(String[] rawArgs) throws Exception {
        GenericOptionsParser parser = new GenericOptionsParser(rawArgs);
        Configuration conf = parser.getConfiguration();
        String[] args = parser.getRemainingArgs();

        // Set denom from command line arguments
        shareDenom(args[2], conf);

        // Setting up mapreduce job to load in graph
        Job job = new Job(conf, "load graph");
        job.setJarByClass(SmallWorld.class);

        job.setMapOutputKeyClass(LongWritable.class);
        job.setMapOutputValueClass(LongWritable.class);
        job.setOutputKeyClass(LongWritable.class);
        job.setOutputValueClass(Text.class);

        job.setMapperClass(LoaderMap.class);
        job.setReducerClass(LoaderReducer.class);

        job.setInputFormatClass(SequenceFileInputFormat.class);
        job.setOutputFormatClass(SequenceFileOutputFormat.class);

        // Input from command-line argument, output to predictable place
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path("bfs-0-out"));

        // Actually starts job, and waits for it to finish
        job.waitForCompletion(true);

        // Example of reading a counter
        //System.out.println("Read in " + 
	//                   job.getCounters().findCounter(ValueUse.EDGE).getValue() + 
	//                 " edges");


	long pre = -1;//job.getCounters().findCounter(ValueUse.EDGE).getValue();
        // Repeats your BFS mapreduce
        int i=0;

        // Will need to change terminating conditions to respond to data
        while (i < MAX_ITERATIONS) {

            job = new Job(conf, "bfs" + i);
            job.setJarByClass(SmallWorld.class);

            job.setMapOutputKeyClass(LongWritable.class);
            job.setMapOutputValueClass(Text.class);
            job.setOutputKeyClass(LongWritable.class);
            job.setOutputValueClass(Text.class);

            job.setMapperClass(BFSMapper.class);
            job.setReducerClass(BFSReducer.class);

            job.setInputFormatClass(SequenceFileInputFormat.class);
            job.setOutputFormatClass(SequenceFileOutputFormat.class);

            // Notice how each mapreduce job gets gets its own output dir

            FileInputFormat.addInputPath(job, new Path("bfs-" + i + "-out"));
            FileOutputFormat.setOutputPath(job, new Path("bfs-"+ (i+1) +"-out"));

            job.waitForCompletion(true);

	    //String path = SmallWorld.class.getResource("SmallWorld.class").getPath();
	    //System.out.println(path.substring(0, path.lastIndexOf("/")));

	    //File file = new File(path.substring(0, path.lastIndexOf("/")) + "/bfs-" + i + "-cleaned-out");

	    //	    System.out.println("Deleted Cleaned out?:" + file.delete());
           

	    //file = new File("~/Git/cs61c-ip/proj1/bfs-" + (i+1) + "-out");

	    //System.out.println("Deleted Out?"+file.delete());

	    i += 1;//hadoop jar sw.jar SmallWorld p1data/ out 2
	    long cur = job.getCounters().findCounter(ValueUse.EDGE).getValue();
	    System.out.println("previous: " + pre);
	    System.out.println("current: " + cur);
	    if (cur == pre) {
		break;
	    }
	    pre = cur;
        }


	job = new Job(conf, "bfs-cleaned" + i);
            job.setJarByClass(SmallWorld.class);

            job.setMapOutputKeyClass(LongWritable.class);
            job.setMapOutputValueClass(Text.class);
            job.setOutputKeyClass(LongWritable.class);
            job.setOutputValueClass(Text.class);

            job.setMapperClass(CleanMapper.class);
            job.setReducerClass(CleanReducer.class);

            job.setInputFormatClass(SequenceFileInputFormat.class);
            job.setOutputFormatClass(SequenceFileOutputFormat.class);

            // Notice how each mapreduce job gets gets its own output dir
            FileInputFormat.addInputPath(job,
 new Path("bfs-" + i + "-out"));
            FileOutputFormat.setOutputPath(job, new Path("bfs-"+ i +"-cleaned-out"));

            job.waitForCompletion(true);




        // Mapreduce config for histogram computation
        job = new Job(conf, "hist");
        job.setJarByClass(SmallWorld.class);

        job.setMapOutputKeyClass(LongWritable.class);
        job.setMapOutputValueClass(LongWritable.class);
        job.setOutputKeyClass(LongWritable.class);
        job.setOutputValueClass(LongWritable.class);

        job.setMapperClass(HistMapper.class);
        //job.setCombinerClass(Reducer.class);
        job.setReducerClass(HistReducer.class);

        job.setInputFormatClass(SequenceFileInputFormat.class);
        job.setOutputFormatClass(TextOutputFormat.class);

        // By declaring i above outside of loop conditions, can use it
        // here to get last bfs output to be input to histogram

        FileInputFormat.addInputPath(job, new Path("bfs-"+ i +"-cleaned-out"));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
}
/*
  CS 61C Project1: Small World

  Name:
  Login:

  Name:
  Login:
 */


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.Math;
import java.util.*;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.filecache.DistributedCache;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.ArrayWritable;
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
    // Maximum depth for any breadth-first search
    public static final int MAX_ITERATIONS = 10;

    // Skeleton code uses this to share denom cmd-line arg across cluster
    public static final String DENOM_PATH = "denom.txt";
    
    public static  int flag = 0;

    // Example enumerated type, used by EValue and Counter example
    public static enum ValueUse {EDGE};
    
    public static class LongArrayWritable extends ArrayWritable {
        public LongArrayWritable() {
            super(LongWritable.class);
        }
        public LongArrayWritable(LongWritable[] values) {
            super(LongWritable.class, values);
        }
    }
    
    // Example writable type
    public static class EValue implements Writable {
        public String use;
        public String value;

        public EValue(String name, String value) {
            this.use = name;
            this.value = value;
            
        }

        // Serializes object - needed for Writable
        public void write(DataOutput out) throws IOException {
            //this.use.write(out);
            //this.value.write(out);
        }

        // Deserializes object - needed for Writable
        public void readFields(DataInput in) throws IOException {
            //this.use.readFields(in);
            //this.value.readFields(in);
        }
        
        
        
        
        public void set(String name, String value) {
            this.use = name;
            this.value = value;
        }

        public String toString() {
            return use + value;
        }
    }

    

    /* This example mapper loads in all edges but only propagates a subset.
       You will need to modify this to propagate all edges, but it is 
       included to demonstate how to read & use the denom argument.         */
    public static class LoaderMap extends Mapper<LongWritable, LongWritable, LongWritable, LongWritable> {
        public long denom;

        /* Setup is called automatically once per map task. This will
           read denom in from the DistributedCache, and it will be
           available to each call of map later on via the instance
           variable.                                                  */
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

        /* Will need to modify to not loose any edges. */
        @Override
        public void map(LongWritable key, LongWritable value, Context context)
                throws IOException, InterruptedException {
            // Send edge forward only if part of random subset
        	
        	/*
        	FileWriter fstream = new FileWriter(key.toString() +".txt");
            BufferedWriter out = new BufferedWriter(fstream);
        	out.write(value.toString());
            out.close();
            */
            context.write(key, value);
           
            // Example of using a counter (counter tagged by EDGE)
            context.getCounter(ValueUse.EDGE).increment(1);
        }
    }


    /* Insert your mapreduces here
       (still feel free to edit elsewhere) */
    public static class LoaderReduce extends Reducer<LongWritable, LongWritable, LongWritable, Text> {
    	public long denom;
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
        public void reduce(LongWritable key, Iterable<LongWritable> values, Context context) throws IOException,InterruptedException {
        	HashMap<String, String> table = new HashMap<String, String>();
        	String s = new String("-");
            Text t = new Text();
            for (LongWritable value : values) {
                s = s  + value.toString() + ":";
            }
            //if (Math.random() <= (1.0 / denom)){
            if(flag == 0){
            	t.set((new EValue("-0", s)).toString());
            	context.write(key,t);
            	t.clear();
            	flag = 1;
            }
            t.set((new EValue("-10000", s)).toString());
        	context.write(key,t);
        	t.clear();

        }
        //}
    }
    
    public static class TheMapper extends Mapper<LongWritable, Text, LongWritable, Text> {
    	@Override
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            //Key is node n
            //Value is D, Points-To
            //For every point (or key), look at everything it points to.
            //Emit or write to the points to variable with the current distance + 1
            Text word = new Text();
            String line = value.toString();//looks like 1 0 2:3:
            line = line.replaceAll("\\s", "");
            String[] sp = line.split("-");//splits on space
            int distanceadd = Integer.parseInt(sp[1]) + 1;
            String[] PointsTo = sp[2].split(":");
            for(int i=0; i<PointsTo.length; i++){
                word.set("VALUE "+distanceadd);//tells me to look at distance value
                context.write(new LongWritable(Integer.parseInt(PointsTo[i])), word);
                word.clear();
            }
            //pass in current node's distance (if it is the lowest distance)
            word.set("VALUE "+sp[1]);
            context.write( new LongWritable( Integer.parseInt( sp[0] ) ), word );
            word.clear();
 
            word.set("NODES "+sp[2]);
            context.write( new LongWritable( Integer.parseInt( sp[0] ) ), word );
            word.clear();
 
        }
    }
 
    public static class TheReducer extends Reducer<LongWritable, Text, LongWritable, Text> {
    	@Override
        public void reduce(LongWritable key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            //The key is the current point
            //The values are all the possible distances to this point
            //we simply emit the point and the minimum distance value
 
            String nodes = "UNMODED";
            Text word = new Text();
            int lowest = 10009;//start at infinity
 
            for (Text val : values) {//looks like NODES/VALUES 1 0 2:3:, we need to use the first as a key
                String[] sp = val.toString().split(" ");//splits on space
                //look at first value
                if(sp[0].equalsIgnoreCase("NODES")){
                    nodes = null;
                    nodes = sp[1];
                }else if(sp[0].equalsIgnoreCase("VALUE")){
                    int distance = Integer.parseInt(sp[1]);
                    lowest = Math.min(distance, lowest);
                }
            }
            word.set("-"+lowest+"-"+nodes);
            context.write(key, word);
            word.clear();
        }
    }
    
// FINAL MAP-REDUCE
    public static class FinalMapper extends Mapper<LongWritable, Text, LongWritable, Text> {
    	@Override 
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        	Text word = new Text();
            String line = value.toString();
            line = line.replaceAll("\\s", "");
            String[] sp = line.split("-");
            word.set("-"+sp[0]);
            context.write( new LongWritable( Integer.parseInt( sp[1] ) ), word );

        }
    }
 
    public static class FinalReducer extends Reducer<LongWritable, Text, LongWritable, Text> {
    	@Override
        public void reduce(LongWritable key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        	Text word = new Text();
        	String s = new String("");
        	
        	for (Text val : values) {
        		s=s+val.toString();
        	}
        	String [] count = s.split("-");
        	word.set("" + (count.length-1));
            context.write(key, word);
            word.clear();
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
        job.setReducerClass(LoaderReduce.class);

        job.setInputFormatClass(SequenceFileInputFormat.class);
        //job.setOutputFormatClass(SequenceFileOutputFormat.class);
        job.setOutputFormatClass(TextOutputFormat.class);

        // Input from command-line argument, output to predictable place
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path("bfs-0-out"));
        
        // Actually starts job, and waits for it to finish
        job.waitForCompletion(true);

        // Example of reading a counter
        System.out.println("Read in " + 
                   job.getCounters().findCounter(ValueUse.EDGE).getValue() + 
                           " edges");
        
        // Repeats your BFS mapreduce
        int i=0;
        // Will need to change terminating conditions to respond to data
        while (i<MAX_ITERATIONS) {
            job = new Job(conf, "bfs" + i);
            job.setJarByClass(SmallWorld.class);

            job.setMapOutputKeyClass(LongWritable.class);
            job.setMapOutputValueClass(Text.class);
            job.setOutputKeyClass(LongWritable.class);
            job.setOutputValueClass(Text.class);

            job.setMapperClass(TheMapper.class);
            job.setReducerClass(TheReducer.class);

            
            job.setInputFormatClass(TextInputFormat.class);
            //job.setInputFormatClass(SequenceFileInputFormat.class);
            //job.setOutputFormatClass(SequenceFileOutputFormat.class);
            job.setOutputFormatClass(TextOutputFormat.class);
            
            // Notice how each mapreduce job gets gets its own output dir
            FileInputFormat.addInputPath(job, new Path("bfs-" + i + "-out"));
            FileOutputFormat.setOutputPath(job, new Path("bfs-"+ (i+1) +"-out"));

            job.waitForCompletion(true);
            i++;
            
        }


        // Mapreduce config for histogram computation
        job = new Job(conf, "hist");
        job.setJarByClass(SmallWorld.class);

        job.setMapOutputKeyClass(LongWritable.class);
        job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(LongWritable.class);
        //job.setOutputValueClass(LongWritable.class);
        job.setMapOutputValueClass(Text.class);
        
        job.setMapperClass(FinalMapper.class);
        //job.setCombinerClass(Reducer.class);
        job.setReducerClass(FinalReducer.class);

        job.setInputFormatClass(TextInputFormat.class);
        //job.setInputFormatClass(SequenceFileInputFormat.class);
        job.setOutputFormatClass(TextOutputFormat.class);

        // By declaring i above outside of loop conditions, can use it
        // here to get last bfs output to be input to histogram
        FileInputFormat.addInputPath(job, new Path("bfs-"+ i +"-out"));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
        
    }
}

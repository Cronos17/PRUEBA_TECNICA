public with sharing class WrapperReddit_Cls {


	public Post data;

    public class Post {
		public List<Children> children;
	}
	public class Children {
		public Data data;
	}

	public class Data {
        public String title;
		public String selftext;
		public String author_fullname;
        public String thumbnail;
        public String created;
	}
	
	public static WrapperReddit_Cls parse(String json) {
		return (WrapperReddit_Cls) System.JSON.deserialize(json, WrapperReddit_Cls.class);
	}

}
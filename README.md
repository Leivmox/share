**mybetis**

```
@Mapper
public interface ConmendHapper {

    @Select("select *from t_comment where a_id=f{aid}")
    public List<Comnent> findById(Integer aId);
    @Insert("INSERT INTo t_comment(id,content,author,a_id)"+"values(#{id},#{content},#fauthor},#{aId})")
public Conment insertComment(Conment comnent);}
```

```
@Component
@Data
@Entity(name = "t_comment")
public class Comment {
    @Id
    @GeneratedValve(strategy=GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    @Column(name ="content")
    private String content;
    @Column(name = "author")
    private String author;
    @Column(name = "a_id")private Integer ald;}
```

```
public class UserController {
    @Autowired
    ConmendMapper conmendHapper;
    RRequestHapping("/comment.html")
    public String getcomment(Integer aId, Model model) {
        ListcConment> comnentList;
        commendapper.findById(ald);
        model,addAttribute( attributeName:"commentlist", commentList);return "conment";
        @ReqvestMapping("/success.html")}
    
        public String insertcomment(comment comment,@RequestParan(value = "ald",required = false)Integer aId) {
            commendHapper, insertconment(comment);
            return "redirect:conment.html2aId=" + aId;
        }
}
```

**JPA**

```
@Repository
public interface CommentRepository extends JpaRepository<Comment, Integer> {

    @Query(value: "select * from t_comment where a_id=?1",nativeQuery=true)
    public List<Comment>findCommentByAId(Integer aid);}
```

```
@Service
@Component
public class AcService {

    @Autowired 
    private CommentRepositorycommentRepository;
    public List<Comment> getAllComment(Integer aid)
    {List<Comment> list=commentRepository.findCommentByAId(aid);
        return list;}
```

```
@RequestMapping("/comment.html")
public String getcomment(Integer aid,Model model)
        {List<Comment> commentList=acService.getAllComment(aid);
            model.addAttribute( attributeName: "commentlist",commentList),
        return "comment";
        }
```

```
RequestMapping("/success.html")
public String insertComment(comment comment,@RequestParam(value = "aId",required = false)
Intege( aid)fcommentRepository.save(connent);
        return "redirect:connent.html2aid:"+a1d;}
```


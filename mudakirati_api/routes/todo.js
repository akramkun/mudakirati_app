const router = require('express').Router();
const Todo = require('../models/todo');

router.get('/', (req, res) => {
    Todo.find().exec((err, todos) => {
        if (err) {
            return res.json({ error: err });
        } else {
            return res.json({ data: todos });
        }
    })
});

router.post('/create', (req, res) => {
    const todo = Todo({
        title: req.body.title,
        content: req.body.content,
    });
    todo.save((err, todo) => {
        if (err) {
            return res.json({ error: err });
        } else {
            return res.json({ data: todo });
        }
    });
});

router.put('/:id', (req, res) => {
    Todo.findById(req.params.id).exec((err, todo) => {
        if (err) {
            return res.json({ error: err });
        }
        todo.title = req.body.title ?? todo.title,
            todo.content = req.body.content ?? todo.content,
            todo.completed = req.body.completed ?? todo.completed,
            todo.save((err, todo) => {
                if (err) {
                    return res.json({ error: err });
                }
                return res.json({ date: todo });
            })


    })
});

router.delete('/:id', (req, res) => {
    Todo.deleteOne({
        _id: req.params.id,
    }).exec((err, result) => {
        if (err) {
            return res.json({ error: err });
        }
        if (result.deletedCount == 0) {
            return res.json({ data: 'Todo not found' });
        }
        return res.json({ data: 'Deleted successfully' });
    })
});

router.post('/deletemany', (req, res) => {
    const {todoIds} = req.body;
    Todo.deleteMany({
        _id: { $in: todoIds }
    }).exec((err, result) => {
        if (err) {
            return res.json({ error: err });
        }
        if (result.deletedCount == 0) {
            return res.json({ data: 'Todo not found' });
        }
        return res.json({ data: 'Deleted successfully' });
    })
});

router.get("/search", async (req, res) => {
    try{
            const userQuery = req.query.q;
            const filteredTodos = await Todo.find({
                $or: [
                    { title: { $regex: userQuery, $options: 'i' } },
                    { content: { $regex: userQuery, $options: 'i' } },
                  ],
            });

            res.json({data: filteredTodos})
    }catch(err){
      res.send(err.message)
    }
  });
module.exports = router;

const mongoose = require('mongoose');
const schema = mongoose.Schema;
const model = mongoose.model;

const todoSchema = new schema({
    title: {
        type: String,
        required: true,
    },
    content: {
        type: String,
        require: false,
    },
    completed: {
        type: Boolean,
        default: false,
    },
    reminder: {
        type: String,
        default: 'non',
    },

}, {
    timestamps: true,
});
todoSchema.index({ title: 'text', content: 'text' });

module.exports = model('Todo', todoSchema);

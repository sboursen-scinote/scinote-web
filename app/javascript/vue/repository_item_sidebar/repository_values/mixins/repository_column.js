export default {
  props: {
    colId: Number,
    colVal: String,
    inArchivedRepository: Boolean,
  },
  data() {
    return {
      columnValue: this.colVal,
      editing: false,
    };
  },
  methods: {
    updateColumnValue(newValue) { // override this method in the component
      this.columnValue = newValue;
    },
    update(newValue) {
      this.updateColumnValue(newValue);
      this.$emit('update', { column_id: this.colId, data: this.columnValue });
    },
  },
};
